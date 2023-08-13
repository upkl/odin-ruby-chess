# frozen_string_literal: true

# data for the chess pieces
class PieceType
  attr_reader :char_on_dark, :char_on_light, :color, :type, :letter

  def initialize(char_on_dark, char_on_light, color, type, letter)
    @char_on_dark = char_on_dark
    @char_on_light = char_on_light
    @color = color
    @type = type
    @letter = letter
  end
end

# A square on the board
class Square
  attr_reader :name, :color
  attr_accessor :piece

  def initialize(name, color)
    @name = name
    @color = color
    @piece = nil
  end

  def to_s
    if @color == :light
      "\e[30;47m#{@piece.nil? ? ' ' : @piece.char_on_light}\e[0m"
    else
      "\e[37;40m#{@piece.nil? ? ' ' : @piece.char_on_dark}\e[0m"
    end
  end
end

WHITE_KING = PieceType.new('♚', '♔', :white, :king, 'K')
WHITE_QUEEN = PieceType.new('♛', '♕', :white, :queen, 'Q')
WHITE_ROOK = PieceType.new('♜', '♖', :white, :rook, 'R')
WHITE_BISHOP = PieceType.new('♝', '♗', :white, :bishop, 'B')
WHITE_KNIGHT = PieceType.new('♞', '♘', :white, :knight, 'N')
WHITE_PAWN = PieceType.new('♟', '♙', :white, :pawn, 'P')
BLACK_KING = PieceType.new('♔', '♚', :black, :king, 'k')
BLACK_QUEEN = PieceType.new('♕', '♛', :black, :queen, 'q')
BLACK_ROOK = PieceType.new('♖', '♜', :black, :rook, 'r')
BLACK_BISHOP = PieceType.new('♗', '♝', :black, :bishop, 'b')
BLACK_KNIGHT = PieceType.new('♘', '♞', :black, :knight, 'n')
BLACK_PAWN = PieceType.new('♙', '♟', :black, :pawn, 'p')

PIECES = {
  'K' => WHITE_KING,
  'Q' => WHITE_QUEEN,
  'R' => WHITE_ROOK,
  'B' => WHITE_BISHOP,
  'N' => WHITE_KNIGHT,
  'P' => WHITE_PAWN,
  'k' => BLACK_KING,
  'q' => BLACK_QUEEN,
  'r' => BLACK_ROOK,
  'b' => BLACK_BISHOP,
  'n' => BLACK_KNIGHT,
  'p' => BLACK_PAWN
}.freeze

DIR_STRAIGHT = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze
DIR_DIAGONAL = [[1, 1], [1, -1], [-1, -1], [-1, 1]].freeze
DIR_ALL = DIR_STRAIGHT + DIR_DIAGONAL
DIR_KNIGHT = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]].freeze

# the chessboard, also containing the game logic
class Board
  attr_reader :active_color, :fullmove_number

  def initialize(fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    pieces_code, @active_color, @castling, @en_passant, @halfmove_clock, @fullmove_number = fen.split

    @active_color = (@active_color == 'w' ? :white : :black)
    @en_passant = nil if @en_passant == '-'
    @castling = '' if @castling == '-'
    @halfmove_clock = @halfmove_clock.to_i
    @fullmove_number = @fullmove_number.to_i

    @squares = {}
    (1..8).each do |rank|
      'abcdefgh'.chars.each do |file|
        name = file + rank.to_s
        color = (file.ord + rank).even? ? :dark : :light
        @squares[name] = Square.new(name, color)
      end
    end
    return unless pieces_code

    codes = pieces_code.split('/')
    (1..8).each do |rank|
      file = 'a'
      codes[8 - rank].chars.each do |c|
        if c.between?('1', '8')
          file = (file.ord + c.to_i).chr
        else
          @squares[file + rank.to_s].piece = PIECES[c]
          file = file.next
        end
      end
    end
  end

  def to_fen
    figures = []
    (1..8).each do |rank|
      code = ''
      empty_seq = 0
      'abcdefgh'.chars.each do |file|
        name = file + rank.to_s
        if @squares[name].piece.nil?
          empty_seq += 1
        else
          if empty_seq.positive?
            code += empty_seq.to_s
            empty_seq = 0
          end
          code += @squares[name].piece.letter
        end
      end
      code += empty_seq.to_s if empty_seq.positive?
      figures << code
    end
    fen = figures.reverse.join('/')

    fen += if @active_color == :white
             ' w'
           else
             ' b'
           end

    fen += if @castling == ''
             ' -'
           else
             " #{@castling}"
           end

    fen += if @en_passant.nil?
             ' -'
           else
             " #{@en_passant}"
           end

    "#{fen} #{@halfmove_clock} #{@fullmove_number}"
  end

  def to_s(reversed: false)
    if reversed
      result = " hgfedcba \n"
      (1..8).each do |rank|
        result += rank.to_s
        'hgfedcba'.chars.each do |file|
          result += @squares[file + rank.to_s].to_s
        end
        result += "#{rank}\n"
      end
      result += ' hgfedcba '
    else
      result = " abcdefgh \n"
      (1..8).to_a.reverse.each do |rank|
        result += rank.to_s
        'abcdefgh'.chars.each do |file|
          result += @squares[file + rank.to_s].to_s
        end
        result += "#{rank}\n"
      end
      result += ' abcdefgh '
    end
  end

  def check?(color: @active_color)
    king = @squares.filter do |_, square|
      square.piece && square.piece.color == color && square.piece.type == :king
    end
    king = king.keys[0]
    check = attacked?(king, color == :white ? :black : :white)
    moves = possible_moves
    moves.filter! { |m| move_safe_for_king?(m) }
    if check
      if moves.empty?
        :checkmate
      else
        :check
      end
    elsif moves.empty?
      :stalemate
    end
  end

  def attacked?(square, color)
    possible_attackers = possible_moves(color: color, attack: square)
    possible_attackers.reject! { |m| m.instance_of?(Symbol) }
    possible_attackers.filter! { |m| m[:dest] == square }
    possible_attackers.reject! { |m| m[:piece].type == :pawn && m[:origin][0] == m[:dest][0] }
    !possible_attackers.empty?
  end

  def possible_moves(given_origin: nil, color: @active_color, attack: nil)
    possible_origins = if given_origin.nil?
                         (@squares.filter { |_, square| !square.piece.nil? && square.piece.color == color }).keys
                       else
                         [given_origin]
                       end
    result = []
    possible_origins.each do |origin|
      tmp_result = []
      piece = @squares[origin].piece
      case piece.type
      when :king
        DIR_ALL.each { |dir| tmp_result += dests(origin, dir, 1) }
        case color
        when :white
          if @castling.include?('Q') \
            && @squares['b1'].piece.nil? && @squares['c1'].piece.nil? && @squares['d1'].piece.nil?
            result << :white_queenside_castling
          end
          if @castling.include?('K') \
            && @squares['f1'].piece.nil? && @squares['g1'].piece.nil?
            result << :white_kingside_castling
          end
        when :black
          if @castling.include?('q') \
            && @squares['b8'].piece.nil? && @squares['c8'].piece.nil? && @squares['d8'].piece.nil?
            result << :black_queenside_castling
          end
          if @castling.include?('k') \
            && @squares['f8'].piece.nil? && @squares['g8'].piece.nil?
            result << :black_kingside_castling
          end
        end
      when :queen
        DIR_ALL.each { |dir| tmp_result += dests(origin, dir, 8) }
      when :rook
        DIR_STRAIGHT.each { |dir| tmp_result += dests(origin, dir, 8) }
      when :bishop
        DIR_DIAGONAL.each { |dir| tmp_result += dests(origin, dir, 8) }
      when :knight
        DIR_KNIGHT.each { |dir| tmp_result += dests(origin, dir, 1) }
      when :pawn
        next_moving = next_square(origin,
                                  color == :white ? [0, 1] : [0, -1])
        origin_is_baseline = origin[1] == (color == :white ? '2' : '7')
        tmp_result << next_moving if @squares[next_moving].piece.nil?
        if @squares[next_moving].piece.nil? && origin_is_baseline
          next_moving2 = next_square(origin,
                                     color == :white ? [0, 2] : [0, -2])
          tmp_result << next_moving2 if @squares[next_moving2].piece.nil?
        end
        next_capture1 = next_square(origin,
                                    color == :white ? [1, 1] : [1, -1])
        can_capture1 = next_capture1 && (
          (@squares[next_capture1].piece && @squares[next_capture1].piece.color != color) \
          || next_capture1 == attack \
          || next_capture1 == @en_passant)
        tmp_result << next_capture1 if can_capture1
        next_capture2 = next_square(origin,
                                    color == :white ? [-1, 1] : [-1, -1])
        can_capture2 =  next_capture2 && (
          (@squares[next_capture2].piece && @squares[next_capture2].piece.color != color) \
          || next_capture2 == attack \
          || next_capture2 == @en_passant)
        tmp_result << next_capture2 if can_capture2
      end
      result += tmp_result.map { |d| { piece: piece, origin: origin, dest: d } }
    end
    result
  end

  def move_safe_for_king?(args)
    case args
    when :white_kingside_castling
      !(attacked?('e1', :black) || attacked?('f1', :black) || attacked?('g1', :black))
    when :white_queenside_castling
      !(attacked?('e1', :black) || attacked?('d1', :black) || attacked?('c1', :black))
    when :black_kingside_castling
      !(attacked?('e8', :white) || attacked?('f8', :white) || attacked?('g8', :white))
    when :black_queenside_castling
      !(attacked?('e8', :white) || attacked?('d8', :white) || attacked?('c8', :white))
    else
      b1 = clone
      b1.move(args)
      king = b1.squares.filter do |_, square|
        square.piece && square.piece.color == args[:piece].color && square.piece.type == :king
      end
      king = king.keys[0]
      !b1.attacked?(king, args[:piece].color == :white ? :black : :white)
    end
  end

  def move(args)
    reset_halfmove_clock = false

    case args
    when :white_kingside_castling
      @squares['e1'].piece = nil
      @squares['g1'].piece = WHITE_KING
      @squares['h1'].piece = nil
      @squares['f1'].piece = WHITE_ROOK
      @castling.sub!('K', '')
      @castling.sub!('Q', '')
      @en_passant = nil
    when :white_queenside_castling
      @squares['e1'].piece = nil
      @squares['g1'].piece = WHITE_KING
      @squares['a1'].piece = nil
      @squares['d1'].piece = WHITE_ROOK
      @castling.sub!('K', '')
      @castling.sub!('Q', '')
      @en_passant = nil
    when :black_kingside_castling
      @squares['e8'].piece = nil
      @squares['g8'].piece = BLACK_KING
      @squares['h8'].piece = nil
      @squares['f8'].piece = BLACK_ROOK
      @castling.sub!('k', '')
      @castling.sub!('q', '')
      @en_passant = nil
    when :black_queenside_castling
      @squares['e8'].piece = nil
      @squares['g8'].piece = BLACK_KING
      @squares['a8'].piece = nil
      @squares['d8'].piece = BLACK_ROOK
      @castling.sub!('k', '')
      @castling.sub!('q', '')
      @en_passant = nil
    else
      piece = args[:piece]
      origin = args[:origin]
      dest = args[:dest]
      reset_halfmove_clock = true if @squares[dest].piece || @squares[origin].piece.type == :pawn
      @squares[dest].piece = @squares[origin].piece
      @squares[origin].piece = nil
      if piece.type == :pawn && dest == @en_passant
        if piece.color == :white
          @squares["#{@en_passant[0]}5"].piece = nil
        else
          @squares["#{@en_passant[0]}4"].piece = nil
        end
      end
      if @castling != ''
        case piece
        when WHITE_KING
          @castling.sub!('K', '')
          @castling.sub!('Q', '')
        when BLACK_KING
          @castling.sub!('k', '')
          @castling.sub!('q', '')
        when WHITE_ROOK
          case origin
          when 'a1'
            @castling.sub!('Q', '')
          when 'h1'
            @castling.sub!('K', '')
          end
        when BLACK_ROOK
          case origin
          when 'a8'
            @castling.sub!('q', '')
          when 'h8'
            @castling.sub!('k', '')
          end
        end
      end
      @en_passant = if piece.type == :pawn
                      if piece.color == :white && origin[1] == '2' && dest[1] == '4'
                        "#{origin[0]}3"
                      elsif piece.color == :black && origin[1] == '7' && dest[1] == '5'
                        "#{origin[0]}6"
                      end
                    end
    end
    @fullmove_number += 1 if @active_color == :black
    @halfmove_clock = reset_halfmove_clock ? 0 : @halfmove_clock + 1
    @active_color = @active_color == :white ? :black : :white
  end

  def decode_move(move_string)
    move_string = move_string.gsub(/[^a-hKQRBNO0-8]/, '')
    case move_string
    when 'OO', '00'
      if @active_color == :white
        return :white_kingside_castling if possible_moves.include?(:white_kingside_castling)
      elsif possible_moves.include?(:black_kingside_castling)
        return :black_kingside_castling
      end
      return nil
    when 'OOO', '000'
      if @active_color == :white
        return :white_queenside_castling if possible_moves.include?(:white_queenside_castling)
      elsif possible_moves.include?(:black_queenside_castling)
        return :black_queenside_castling
      end
      return nil
    end
    piece = move_string[0]
    if piece.between?('A', 'Z')
      move_string = move_string[1..]
    else
      piece = 'P'
    end
    piece = piece.downcase if @active_color == :black
    piece = PIECES[piece]

    dest = move_string[-2..]
    origin = move_string[...-2]

    if origin.empty?
      possible = possible_moves.filter do |m|
        !m.instance_of?(Symbol) && m[:dest] == dest && m[:piece] == piece
      end
    elsif origin.length == 1 && origin.between?('a', 'h')
      possible = possible_moves.filter do |m|
        !m.instance_of?(Symbol) && m[:origin][0] == origin && m[:dest] == dest && m[:piece] == piece
      end
    elsif origin.length == 1 && origin.between?('1', '8')
      possible = possible_moves.filter do |m|
        !m.instance_of?(Symbol) && m[:origin][1] == origin && m[:dest] == dest && m[:piece] == piece
      end
    elsif origin.length == 2
      possible = possible_moves.filter do |m|
        !m.instance_of?(Symbol) && m[:origin] == origin && m[:dest] == dest && m[:piece] == piece
      end
    else
      return nil
    end
    possible.filter! { |m| move_safe_for_king?(m) }
    possible[0] if possible.length == 1
  end

  def clone
    Board.new(to_fen)
  end

  private

  def next_square(origin, dir)
    next_file = (origin[0].ord + dir[0]).chr
    next_rank = (origin[1].ord + dir[1]).chr
    return nil unless next_file.between?('a', 'h') && next_rank.between?('1', '8')

    next_file + next_rank
  end

  def dests(origin, dir, maxlen)
    own_color = @squares[origin].piece.color
    result = []

    loop do
      square = next_square(origin, dir)

      return result if square.nil?
      return result if @squares[square].piece && @squares[square].piece.color == own_color

      result << square
      return result if @squares[square].piece && @squares[square].piece.color != own_color
      return result if result.length >= maxlen

      origin = square
    end
  end

  protected

  def squares
    @squares
  end
end

# wrapper for the chessboard to allow player interaction
class Game
  def run
    while @board.check? != :checkmate && @board.check? != :stalemate
      puts
      puts to_s
      puts 'Check!' if @board.check? == :check
      if @board.active_color == :white
        print "#{@board.fullmove_number}. "
      else
        print "#{@board.fullmove_number}. … "
      end
      move = @board.decode_move(gets)
      if move
        @board.move(move)
      else
        puts 'Move not possible, try again'
      end
    end
    puts 'Checkmate!' if @board.check? == :checkmate
    puts 'Stalemate!' if @board.check? == :stalemate
  end

  def initialize(fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    @board = Board.new(fen)
  end

  def to_s
    if @board.active_color == :white
      @board.to_s
    else
      @board.to_s(reversed: true)
    end
  end
end
