# frozen_string_literal: true

require './lib/chess'

describe Square do
  describe '#to_s' do
    context 'for a light square' do
      subject(:square) { described_class.new('d1', :light) }
      it 'returns the correct value when empty' do
        expect(square.to_s).to eq("\e[30;47m \e[0m")
      end
      it 'returns the correct value with a white piece' do
        square.piece = WHITE_KING
        expect(square.to_s).to eq("\e[30;47m♔\e[0m")
      end
      it 'returns the correct value with a black piece' do
        square.piece = BLACK_ROOK
        expect(square.to_s).to eq("\e[30;47m♜\e[0m")
      end
    end

    context 'for a dark square' do
      subject(:square) { described_class.new('d8', :dark) }
      it 'returns the correct value when empty' do
        expect(square.to_s).to eq("\e[37;40m \e[0m")
      end
      it 'returns the correct value with a white piece' do
        square.piece = WHITE_BISHOP
        expect(square.to_s).to eq("\e[37;40m♝\e[0m")
      end
      it 'returns the correct value with a black piece' do
        square.piece = BLACK_PAWN
        expect(square.to_s).to eq("\e[37;40m♙\e[0m")
      end
    end
  end
end

describe Board do
  describe '#to_s' do
    context 'for an empty board' do
      subject(:board) { described_class.new('8/8/8/8/8/8/8/8 w - - 0 1') }
      it 'returns the correct value' do
        expect(board.to_s).to eq(" abcdefgh \n8\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m " \
                                 "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m8\n7\e[37;40m \e[0m\e[30;47m \e[0" \
                                 "m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;4" \
                                 "7m \e[0m7\n6\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m " \
                                 "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m6\n5\e[37;40m \e[0m\e[30;47m \e[0" \
                                 "m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;4" \
                                 "7m \e[0m5\n4\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m " \
                                 "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m4\n3\e[37;40m \e[0m\e[30;47m \e[0" \
                                 "m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;4" \
                                 "7m \e[0m3\n2\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m " \
                                 "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m2\n1\e[37;40m \e[0m\e[30;47m \e[0" \
                                 "m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;4" \
                                 "7m \e[0m1\n abcdefgh ")
      end
      it 'returns the correct value when viewed from the black side' do
        expect(board.to_s(reversed: true)).to eq(" hgfedcba \n1\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40" \
                                                 "m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m" \
                                                 "1\n2\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[" \
                                                 "37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m2\n3\e[30;" \
                                                 "47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[" \
                                                 "0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m3\n4\e[37;40m \e[0m" \
                                                 "\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;4" \
                                                 "7m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m4\n5\e[30;47m \e[0m\e[37;40m " \
                                                 "\e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e" \
                                                 "[30;47m \e[0m\e[37;40m \e[0m5\n6\e[37;40m \e[0m\e[30;47m \e[0m\e[37" \
                                                 ";40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e" \
                                                 "[0m\e[30;47m \e[0m6\n7\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m" \
                                                 "\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;4" \
                                                 "0m \e[0m7\n8\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m " \
                                                 "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m8" \
                                                 "\n hgfedcba ")
      end
    end
    context 'for the initial position' do
      subject(:board) { described_class.new }
      it 'returns the correct value' do
        expect(board.to_s).to eq(" abcdefgh \n8\e[30;47m♜\e[0m\e[37;40m♘\e[0m\e[30;47m♝\e[0m\e[37;40m♕\e[0m\e[30;47m♚" \
                                 "\e[0m\e[37;40m♗\e[0m\e[30;47m♞\e[0m\e[37;40m♖\e[0m8\n7\e[37;40m♙\e[0m\e[30;47m♟\e[0" \
                                 "m\e[37;40m♙\e[0m\e[30;47m♟\e[0m\e[37;40m♙\e[0m\e[30;47m♟\e[0m\e[37;40m♙\e[0m\e[30;4" \
                                 "7m♟\e[0m7\n6\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m " \
                                 "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m6\n5\e[37;40m \e[0m\e[30;47m \e[0" \
                                 "m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;4" \
                                 "7m \e[0m5\n4\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m " \
                                 "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m4\n3\e[37;40m \e[0m\e[30;47m \e[0" \
                                 "m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;4" \
                                 "7m \e[0m3\n2\e[30;47m♙\e[0m\e[37;40m♟\e[0m\e[30;47m♙\e[0m\e[37;40m♟\e[0m\e[30;47m♙" \
                                 "\e[0m\e[37;40m♟\e[0m\e[30;47m♙\e[0m\e[37;40m♟\e[0m2\n1\e[37;40m♜\e[0m\e[30;47m♘\e[0" \
                                 "m\e[37;40m♝\e[0m\e[30;47m♕\e[0m\e[37;40m♚\e[0m\e[30;47m♗\e[0m\e[37;40m♞\e[0m\e[30;4" \
                                 "7m♖\e[0m1\n abcdefgh ")
      end
      it 'returns the correct value when viewed from the black side' do
        expect(board.to_s(reversed: true)).to eq(" hgfedcba \n1\e[30;47m♖\e[0m\e[37;40m♞\e[0m\e[30;47m♗\e[0m\e[37;40m" \
                                                 "♚\e[0m\e[30;47m♕\e[0m\e[37;40m♝\e[0m\e[30;47m♘\e[0m\e[37;40m♜\e[0m1" \
                                                 "\n2\e[37;40m♟\e[0m\e[30;47m♙\e[0m\e[37;40m♟\e[0m\e[30;47m♙\e[0m\e[3" \
                                                 "7;40m♟\e[0m\e[30;47m♙\e[0m\e[37;40m♟\e[0m\e[30;47m♙\e[0m2\n3\e[30;4" \
                                                 "7m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0" \
                                                 "m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m3\n4\e[37;40m \e[0m\e" \
                                                 "[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47" \
                                                 "m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m4\n5\e[30;47m \e[0m\e[37;40m " \
                                                 "\e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e" \
                                                 "[30;47m \e[0m\e[37;40m \e[0m5\n6\e[37;40m \e[0m\e[30;47m \e[0m\e[37" \
                                                 ";40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e" \
                                                 "[0m\e[30;47m \e[0m6\n7\e[30;47m♟\e[0m\e[37;40m♙\e[0m\e[30;47m♟\e[0m" \
                                                 "\e[37;40m♙\e[0m\e[30;47m♟\e[0m\e[37;40m♙\e[0m\e[30;47m♟\e[0m\e[37;4" \
                                                 "0m♙\e[0m7\n8\e[37;40m♖\e[0m\e[30;47m♞\e[0m\e[37;40m♗\e[0m\e[30;47m♚" \
                                                 "\e[0m\e[37;40m♕\e[0m\e[30;47m♝\e[0m\e[37;40m♘\e[0m\e[30;47m♜\e[0m8" \
                                                 "\n hgfedcba ")
      end
    end
  end

  describe '#to_fen' do
    context 'for an empty board' do
      subject(:board) { described_class.new('8/8/8/8/8/8/8/8 w - - 0 1') }
      it 'returns the correct value' do
        expect(board.to_fen).to eq('8/8/8/8/8/8/8/8 w - - 0 1')
      end
    end
    context 'for the initial position' do
      subject(:board) { described_class.new }
      it 'returns the correct value' do
        expect(board.to_fen).to eq('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
      end
    end
  end

  describe '#initialize' do
    context 'without parameter' do
      subject(:board) { described_class.new }
      it 'initializes the default position' do
        expect(board.to_s).to eq(" abcdefgh \n8\e[30;47m♜\e[0m\e[37;40m♘\e[0m\e[30;47m♝\e[0m\e[37;40m♕\e[0m\e[30;47m♚" \
                                 "\e[0m\e[37;40m♗\e[0m\e[30;47m♞\e[0m\e[37;40m♖\e[0m8\n7\e[37;40m♙\e[0m\e[30;47m♟\e[0" \
                                 "m\e[37;40m♙\e[0m\e[30;47m♟\e[0m\e[37;40m♙\e[0m\e[30;47m♟\e[0m\e[37;40m♙\e[0m\e[30;4" \
                                 "7m♟\e[0m7\n6\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m " \
                                 "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m6\n5\e[37;40m \e[0m\e[30;47m \e[0" \
                                 "m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;4" \
                                 "7m \e[0m5\n4\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m " \
                                 "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m4\n3\e[37;40m \e[0m\e[30;47m \e[0" \
                                 "m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;4" \
                                 "7m \e[0m3\n2\e[30;47m♙\e[0m\e[37;40m♟\e[0m\e[30;47m♙\e[0m\e[37;40m♟\e[0m\e[30;47m♙" \
                                 "\e[0m\e[37;40m♟\e[0m\e[30;47m♙\e[0m\e[37;40m♟\e[0m2\n1\e[37;40m♜\e[0m\e[30;47m♘\e[0" \
                                 "m\e[37;40m♝\e[0m\e[30;47m♕\e[0m\e[37;40m♚\e[0m\e[30;47m♗\e[0m\e[37;40m♞\e[0m\e[30;4" \
                                 "7m♖\e[0m1\n abcdefgh ")
        expect(board.instance_variable_get(:@active_color)).to eq(:white)
        expect(board.instance_variable_get(:@castling).chars.sort).to eq(%w[K Q k q])
        expect(board.instance_variable_get(:@en_passant)).to be_nil
        expect(board.instance_variable_get(:@halfmove_clock)).to be(0)
        expect(board.instance_variable_get(:@fullmove_number)).to be(1)
      end
      context 'for Labourdonnais-McDonnell London 1834, game 1, after black move 10' do
        # https://lichess.org/study/6DTvhRG3
        subject(:board) { described_class.new('r1bq1rk1/p4ppp/2p2b2/3pp3/4P3/1B6/PPP1QPPP/RN2K2R w KQ - 2 11') }
        it 'initializes with the correct values' do
          expect(board.to_s).to eq(" abcdefgh \n8\e[30;47m♜\e[0m\e[37;40m \e[0m\e[30;47m♝\e[0m\e[37;40m♕\e[0m\e[30;47" \
                                   "m \e[0m\e[37;40m♖\e[0m\e[30;47m♚\e[0m\e[37;40m \e[0m8\n7\e[37;40m♙\e[0m\e[30;47m " \
                                   "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m♟\e[0m\e[37;40m♙\e[0m" \
                                   "\e[30;47m♟\e[0m7\n6\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m♟\e[0m\e[37;40m \e[0m\e" \
                                   "[30;47m \e[0m\e[37;40m♗\e[0m\e[30;47m \e[0m\e[37;40m \e[0m6\n5\e[37;40m \e[0m\e[3" \
                                   "0;47m \e[0m\e[37;40m \e[0m\e[30;47m♟\e[0m\e[37;40m♙\e[0m\e[30;47m \e[0m\e[37;40m " \
                                   "\e[0m\e[30;47m \e[0m5\n4\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e" \
                                   "[0m\e[30;47m♙\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m4\n3\e[37;40m \e[0" \
                                   "m\e[30;47m♗\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37" \
                                   ";40m \e[0m\e[30;47m \e[0m3\n2\e[30;47m♙\e[0m\e[37;40m♟\e[0m\e[30;47m♙\e[0m\e[37;4" \
                                   "0m \e[0m\e[30;47m♕\e[0m\e[37;40m♟\e[0m\e[30;47m♙\e[0m\e[37;40m♟\e[0m2\n1\e[37;40m" \
                                   "♜\e[0m\e[30;47m♘\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m♚\e[0m\e[30;47m \e[0m" \
                                   "\e[37;40m \e[0m\e[30;47m♖\e[0m1\n abcdefgh ")
          expect(board.instance_variable_get(:@active_color)).to eq(:white)
          expect(board.instance_variable_get(:@castling).chars.sort).to eq(%w[K Q])
          expect(board.instance_variable_get(:@en_passant)).to be_nil
          expect(board.instance_variable_get(:@halfmove_clock)).to be(2)
          expect(board.instance_variable_get(:@fullmove_number)).to be(11)
        end
      end
      context 'for Lasker-Tarrasch 1908, game 5, after black move 25' do
        # https://lichess.org/study/TFFyOff1
        subject(:board) { described_class.new('r1r2n2/4b1k1/pq2b2p/1p1pPppQ/3p1P2/6BP/PP4P1/1B1RRNK1 w - f6 0 26') }
        it 'initializes with the correct values' do
          expect(board.to_s).to eq(" abcdefgh \n8\e[30;47m♜\e[0m\e[37;40m \e[0m\e[30;47m♜\e[0m\e[37;40m \e[0m\e[30;47" \
                                   "m \e[0m\e[37;40m♘\e[0m\e[30;47m \e[0m\e[37;40m \e[0m8\n7\e[37;40m \e[0m\e[30;47m " \
                                   "\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m♗\e[0m\e[30;47m \e[0m\e[37;40m♔\e[0m" \
                                   "\e[30;47m \e[0m7\n6\e[30;47m♟\e[0m\e[37;40m♕\e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e" \
                                   "[30;47m♝\e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m♙\e[0m6\n5\e[37;40m \e[0m\e[3" \
                                   "0;47m♟\e[0m\e[37;40m \e[0m\e[30;47m♟\e[0m\e[37;40m♟\e[0m\e[30;47m♟\e[0m\e[37;40m♙" \
                                   "\e[0m\e[30;47m♕\e[0m5\n4\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m♙\e" \
                                   "[0m\e[30;47m \e[0m\e[37;40m♟\e[0m\e[30;47m \e[0m\e[37;40m \e[0m4\n3\e[37;40m \e[0" \
                                   "m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m \e[0m\e[37" \
                                   ";40m♝\e[0m\e[30;47m♙\e[0m3\n2\e[30;47m♙\e[0m\e[37;40m♟\e[0m\e[30;47m \e[0m\e[37;4" \
                                   "0m \e[0m\e[30;47m \e[0m\e[37;40m \e[0m\e[30;47m♙\e[0m\e[37;40m \e[0m2\n1\e[37;40" \
                                   "m \e[0m\e[30;47m♗\e[0m\e[37;40m \e[0m\e[30;47m♖\e[0m\e[37;40m♜\e[0m\e[30;47m♘\e[0" \
                                   "m\e[37;40m♚\e[0m\e[30;47m \e[0m1\n abcdefgh ")
          expect(board.instance_variable_get(:@active_color)).to eq(:white)
          expect(board.instance_variable_get(:@castling)).to eq('')
          expect(board.instance_variable_get(:@en_passant)).to eq('f6')
          expect(board.instance_variable_get(:@halfmove_clock)).to be(0)
          expect(board.instance_variable_get(:@fullmove_number)).to be(26)
        end
      end
    end
  end

  describe '#check?' do
    context 'in initial position' do
      subject(:board) { described_class.new }
      it 'reports nothing' do
        expect(board.check?).to be_nil
      end
    end
    context 'for Labourdonnais-McDonnell London 1834, game 1, after black move 10' do
      # https://lichess.org/study/6DTvhRG3
      subject(:board) { described_class.new('r1bq1rk1/p4ppp/2p2b2/3pp3/4P3/1B6/PPP1QPPP/RN2K2R w KQ - 2 11') }
      it 'reports nothing' do
        expect(board.check?).to be_nil
      end
    end
    context 'for Timman, Jan H - Panno, Oscar, game 5, final state' do
      # https://lichess.org/study/6DTvhRG3
      subject(:board) { described_class.new('rr6/1p2Rq1p/2p2kp1/p3Q3/8/P6P/1P3PP1/6K1 b - - 1 41') }
      it 'reports checkmate' do
        expect(board.check?).to be(:checkmate)
      end
    end
    context 'for Timman, Jan H - Panno, Oscar, game 5, after white move 39' do
      # https://lichess.org/study/6DTvhRG3
      subject(:board) { described_class.new('rr3k2/1p3q1p/2p1RNp1/p1Q5/8/P6P/1P3PP1/6K1 b - - 4 39') }
      it 'reports check' do
        expect(board.check?).to be(:check)
      end
    end
    context 'for Keres-Kholmov' do
      # https://lichess.org/study/I5MDlrcy
      subject(:board) { described_class.new('8/7p/5Qpk/8/P5P1/8/5P2/6K1 b - - 0 4') }
      it 'reports stalemate' do
        expect(board.check?).to be(:stalemate)
      end
    end
  end

  describe '#attacked?' do
    context 'in initial position' do
      subject(:board) { described_class.new }
      it 'e5 is not attacked by black' do
        expect(board.attacked?('e5', :black)).to be false
      end
      it 'e6 is attacked by black' do
        expect(board.attacked?('e6', :black)).to be true
      end
    end
    context 'for Labourdonnais-McDonnell London 1834, game 1, after black move 10' do
      # https://lichess.org/study/6DTvhRG3
      subject(:board) { described_class.new('r1bq1rk1/p4ppp/2p2b2/3pp3/4P3/1B6/PPP1QPPP/RN2K2R w KQ - 2 11') }
      it 'e5 is not attacked by white' do
        expect(board.attacked?('e5', :white)).to be false
      end
      it 'd5 is attacked by white' do
        expect(board.attacked?('d5', :white)).to be true
      end
      it 'g4 is attacked by black' do
        expect(board.attacked?('g4', :black)).to be true
      end
      it 'd3 is not attacked by black' do
        expect(board.attacked?('d3', :black)).to be false
      end
    end
  end

  describe '#possible_moves' do
    context 'in initial position' do
      subject(:board) { described_class.new }
      it 'returns the correct 20 moves' do
        moves = board.possible_moves
        # moves.each { |m| puts "#{m[:piece].char_on_dark}#{m[:origin]}-#{m[:dest]}" }
        expect(moves.length).to be(20)
        expect(moves).to include(
          { piece: WHITE_KNIGHT, origin: 'b1', dest: 'a3' },
          { piece: WHITE_KNIGHT, origin: 'b1', dest: 'c3' },
          { piece: WHITE_KNIGHT, origin: 'g1', dest: 'f3' },
          { piece: WHITE_KNIGHT, origin: 'g1', dest: 'h3' },
          { piece: WHITE_PAWN, origin: 'a2', dest: 'a3' },
          { piece: WHITE_PAWN, origin: 'a2', dest: 'a4' },
          { piece: WHITE_PAWN, origin: 'b2', dest: 'b3' },
          { piece: WHITE_PAWN, origin: 'b2', dest: 'b4' },
          { piece: WHITE_PAWN, origin: 'c2', dest: 'c3' },
          { piece: WHITE_PAWN, origin: 'c2', dest: 'c4' },
          { piece: WHITE_PAWN, origin: 'd2', dest: 'd3' },
          { piece: WHITE_PAWN, origin: 'd2', dest: 'd4' },
          { piece: WHITE_PAWN, origin: 'e2', dest: 'e3' },
          { piece: WHITE_PAWN, origin: 'e2', dest: 'e4' },
          { piece: WHITE_PAWN, origin: 'f2', dest: 'f3' },
          { piece: WHITE_PAWN, origin: 'f2', dest: 'f4' },
          { piece: WHITE_PAWN, origin: 'g2', dest: 'g3' },
          { piece: WHITE_PAWN, origin: 'g2', dest: 'g4' },
          { piece: WHITE_PAWN, origin: 'h2', dest: 'h3' },
          { piece: WHITE_PAWN, origin: 'h2', dest: 'h4' }
        )
      end
    end
    context 'for Labourdonnais-McDonnell London 1834, game 1, after black move 10' do
      # https://lichess.org/study/6DTvhRG3
      subject(:board) { described_class.new('r1bq1rk1/p4ppp/2p2b2/3pp3/4P3/1B6/PPP1QPPP/RN2K2R w KQ - 2 11') }
      it 'returns the correct 34 moves' do
        moves = board.possible_moves
        expect(moves.length).to be(34)
        expect(moves).to include(
          { piece: WHITE_KNIGHT, origin: 'b1', dest: 'a3' },
          { piece: WHITE_KNIGHT, origin: 'b1', dest: 'c3' },
          { piece: WHITE_KING, origin: 'e1', dest: 'd1' },
          { piece: WHITE_KING, origin: 'e1', dest: 'd2' },
          { piece: WHITE_KING, origin: 'e1', dest: 'f1' },
          :white_kingside_castling,
          { piece: WHITE_ROOK, origin: 'h1', dest: 'f1' },
          { piece: WHITE_ROOK, origin: 'h1', dest: 'g1' },
          { piece: WHITE_PAWN, origin: 'a2', dest: 'a3' },
          { piece: WHITE_PAWN, origin: 'a2', dest: 'a4' },
          { piece: WHITE_PAWN, origin: 'c2', dest: 'c3' },
          { piece: WHITE_PAWN, origin: 'c2', dest: 'c4' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'd1' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'd2' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'd3' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'e3' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'f3' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'c4' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'g4' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'b5' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'h5' },
          { piece: WHITE_QUEEN, origin: 'e2', dest: 'a6' },
          { piece: WHITE_PAWN, origin: 'f2', dest: 'f3' },
          { piece: WHITE_PAWN, origin: 'f2', dest: 'f4' },
          { piece: WHITE_PAWN, origin: 'g2', dest: 'g3' },
          { piece: WHITE_PAWN, origin: 'g2', dest: 'g4' },
          { piece: WHITE_PAWN, origin: 'h2', dest: 'h3' },
          { piece: WHITE_PAWN, origin: 'h2', dest: 'h4' },
          { piece: WHITE_BISHOP, origin: 'b3', dest: 'a4' },
          { piece: WHITE_BISHOP, origin: 'b3', dest: 'c4' },
          { piece: WHITE_BISHOP, origin: 'b3', dest: 'd5' },
          { piece: WHITE_PAWN, origin: 'e4', dest: 'd5' }
        )
      end
    end

    context 'for Lasker-Tarrasch 1908, game 5, after black move 25' do
      # https://lichess.org/study/TFFyOff1
      subject(:board) { described_class.new('r1r2n2/4b1k1/pq2b2p/1p1pPppQ/3p1P2/6BP/PP4P1/1B1RRNK1 w - f6 0 26') }
      it 'returns the correct 36 moves' do
        moves = board.possible_moves
        expect(moves.length).to be(36)
        expect(moves).to include(
          { piece: WHITE_BISHOP, origin: 'b1', dest: 'c2' },
          { piece: WHITE_BISHOP, origin: 'b1', dest: 'd3' },
          { piece: WHITE_BISHOP, origin: 'b1', dest: 'e4' },
          { piece: WHITE_BISHOP, origin: 'b1', dest: 'f5' },
          { piece: WHITE_ROOK, origin: 'd1', dest: 'c1' },
          { piece: WHITE_ROOK, origin: 'd1', dest: 'd2' },
          { piece: WHITE_ROOK, origin: 'd1', dest: 'd3' },
          { piece: WHITE_ROOK, origin: 'd1', dest: 'd4' },
          { piece: WHITE_ROOK, origin: 'e1', dest: 'e2' },
          { piece: WHITE_ROOK, origin: 'e1', dest: 'e3' },
          { piece: WHITE_ROOK, origin: 'e1', dest: 'e4' },
          { piece: WHITE_KNIGHT, origin: 'f1', dest: 'd2' },
          { piece: WHITE_KNIGHT, origin: 'f1', dest: 'e3' },
          { piece: WHITE_KNIGHT, origin: 'f1', dest: 'h2' },
          { piece: WHITE_KING, origin: 'g1', dest: 'h1' },
          { piece: WHITE_KING, origin: 'g1', dest: 'f2' },
          { piece: WHITE_KING, origin: 'g1', dest: 'h2' },
          { piece: WHITE_PAWN, origin: 'a2', dest: 'a3' },
          { piece: WHITE_PAWN, origin: 'a2', dest: 'a4' },
          { piece: WHITE_PAWN, origin: 'b2', dest: 'b3' },
          { piece: WHITE_PAWN, origin: 'b2', dest: 'b4' },
          { piece: WHITE_BISHOP, origin: 'g3', dest: 'f2' },
          { piece: WHITE_BISHOP, origin: 'g3', dest: 'h2' },
          { piece: WHITE_BISHOP, origin: 'g3', dest: 'h4' },
          { piece: WHITE_PAWN, origin: 'h3', dest: 'h4' },
          { piece: WHITE_PAWN, origin: 'f4', dest: 'g5' },
          { piece: WHITE_PAWN, origin: 'e5', dest: 'f6' },
          { piece: WHITE_QUEEN, origin: 'h5', dest: 'e2' },
          { piece: WHITE_QUEEN, origin: 'h5', dest: 'f3' },
          { piece: WHITE_QUEEN, origin: 'h5', dest: 'g4' },
          { piece: WHITE_QUEEN, origin: 'h5', dest: 'h4' },
          { piece: WHITE_QUEEN, origin: 'h5', dest: 'g5' },
          { piece: WHITE_QUEEN, origin: 'h5', dest: 'g6' },
          { piece: WHITE_QUEEN, origin: 'h5', dest: 'h6' },
          { piece: WHITE_QUEEN, origin: 'h5', dest: 'f7' },
          { piece: WHITE_QUEEN, origin: 'h5', dest: 'e8' }
        )
      end
    end
  end

  describe '#move_safe_for_king?' do
    context 'for Lasker-Tarrasch 1908, game 5, after white move 34' do
      # https://lichess.org/study/TFFyOff1
      subject(:board) { described_class.new('7r/r4bk1/pq4n1/1p1pR1Q1/8/3B2NP/PP4P1/4R2K b - - 2 34') }
      it 'accepts Kg7' do
        expect(board.move_safe_for_king?({ piece: BLACK_KING, origin: 'g7', dest: 'h7' })).to be true
      end
      it 'rejects Kh6' do
        expect(board.move_safe_for_king?({ piece: BLACK_KING, origin: 'g7', dest: 'h6' })).to be false
      end
      it 'rejects Nf4' do
        expect(board.move_safe_for_king?({ piece: BLACK_KNIGHT, origin: 'g6', dest: 'f4' })).to be false
      end
    end
  end

  describe '#decode_move' do
    context 'in initial position' do
      subject(:board) { described_class.new }
      it 'decodes e4' do
        expect(board.decode_move('e4')).to eq({ piece: WHITE_PAWN, origin: 'e2', dest: 'e4' })
      end
      it 'decodes Nf3' do
        expect(board.decode_move('Nf3')).to eq({ piece: WHITE_KNIGHT, origin: 'g1', dest: 'f3' })
      end
    end
    context 'for Labourdonnais-McDonnell London 1834, game 1, after black move 10' do
      # https://lichess.org/study/6DTvhRG3
      subject(:board) { described_class.new('r1bq1rk1/p4ppp/2p2b2/3pp3/4P3/1B6/PPP1QPPP/RN2K2R w KQ - 2 11') }
      it 'decodes ed5' do
        expect(board.decode_move('ed5')).to eq({ piece: WHITE_PAWN, origin: 'e4', dest: 'd5' })
      end
      it 'decodes Be5' do
        expect(board.decode_move('Bd5')).to eq({ piece: WHITE_BISHOP, origin: 'b3', dest: 'd5' })
      end
      it 'decodes O-O' do
        expect(board.decode_move('O-O')).to eq(:white_kingside_castling)
      end
    end
  end

  describe '#move' do
    context 'in initial position' do
      subject(:board) { described_class.new }
      it 'moves e4' do
        board.move(piece: WHITE_PAWN, origin: 'e2', dest: 'e4')
        expect(board.to_fen).to eq('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1')
      end
      it 'moves Nf3' do
        board.move(piece: WHITE_KNIGHT, origin: 'g1', dest: 'f3')
        expect(board.to_fen).to eq('rnbqkbnr/pppppppp/8/8/8/5N2/PPPPPPPP/RNBQKB1R b KQkq - 1 1')
      end
    end
    context 'for Labourdonnais-McDonnell London 1834, game 1, after black move 10' do
      # https://lichess.org/study/6DTvhRG3
      subject(:board) { described_class.new('r1bq1rk1/p4ppp/2p2b2/3pp3/4P3/1B6/PPP1QPPP/RN2K2R w KQ - 2 11') }
      it 'handles castling correctly' do
        board.move(:white_kingside_castling)
        expect(board.to_fen).to eq('r1bq1rk1/p4ppp/2p2b2/3pp3/4P3/1B6/PPP1QPPP/RN3RK1 b - - 3 11')
      end
    end
    context 'for Lasker-Tarrasch 1908, game 5, after black move 25' do
      # https://lichess.org/study/TFFyOff1
      subject(:board) { described_class.new('r1r2n2/4b1k1/pq2b2p/1p1pPppQ/3p1P2/6BP/PP4P1/1B1RRNK1 w - f6 0 26') }
      it 'handles en passant correctly' do
        board.move(piece: WHITE_PAWN, origin: 'e5', dest: 'f6')
        expect(board.to_fen).to eq('r1r2n2/4b1k1/pq2bP1p/1p1p2pQ/3p1P2/6BP/PP4P1/1B1RRNK1 b - - 0 26')
      end
    end
  end

  describe '#clone' do
    context 'for Labourdonnais-McDonnell London 1834, game 1, after black move 10' do
      # https://lichess.org/study/6DTvhRG3
      subject(:board) { described_class.new('r1bq1rk1/p4ppp/2p2b2/3pp3/4P3/1B6/PPP1QPPP/RN2K2R w KQ - 2 11') }
      it 'the clone is not identical' do
        expect(board.clone).not_to eq(board)
      end
      it 'the clone has the same fen string' do
        expect(board.clone.to_fen).to eq('r1bq1rk1/p4ppp/2p2b2/3pp3/4P3/1B6/PPP1QPPP/RN2K2R w KQ - 2 11')
      end
      it 'moves do not change the original board' do
        expect { board.clone.move(piece: WHITE_PAWN, origin: 'e5', dest: 'f6') }.not_to change(board, :to_fen)
      end
    end
  end
end

describe Game do
  describe '#run' do
    context 'for Timman, Jan H - Panno, Oscar, game 5' do
      # https://lichess.org/study/6DTvhRG3
      subject(:game) { described_class.new }
      it 'replays the game' do
        allow(game).to receive(:gets).and_return('d4', 'd5', 'c4', 'dxc4', 'Nc3', 'e5', 'e3', 'exd4', 'exd4', 'Nf6',
                                                 'Bxc4', 'Be7', 'Nf3', 'O-O', 'h3', 'Nbd7', 'O-O', 'Nb6', 'Bb3', 'c6',
                                                 'Re1', 'Nfd5', 'Ne4', 'Re8', 'Bd2', 'Bf5', 'Ng3', 'Be6', 'Bc2', 'Nd7',
                                                 'a3', 'Nf8', 'Bd3', 'g6', 'Bh6', 'Nf6', 'Qd2', 'Bd5', 'Ne5', 'Ne6',
                                                 'Bc2', 'Nd7', 'Ng4', 'Bg5', 'Bxg5', 'Qxg5', 'Qb4', 'Nf6', 'Re5',
                                                 'Qh4', 'Nxf6+', 'Qxf6', 'Ne4', 'Qd8', 'Bb3!', 'a5', 'Qc3', 'Bxb3',
                                                 'Qxb3', 'Qxd4', 'Nf6+', 'Kh8', 'Rae1', 'Reb8?!', 'R1e4!', 'Qd8',
                                                 'Rxe6!', 'fxe6', 'Qc3', 'Qe7', 'Nh5+', 'Kg8', 'Rxe6', 'Qf7', 'Nf6+',
                                                 'Kf8', 'Qc5+', 'Kg7', 'Re7', 'Kxf6', 'Qe5#')
        allow(game).to receive(:puts).and_return(nil)
        allow(game).to receive(:print).and_return(nil)
        expect(game).to receive(:puts).with('Check!').exactly(5).times
        expect(game).to receive(:puts).with('Checkmate!').once
        game.run
        expect(game.instance_variable_get(:@board).to_fen).to eq('rr6/1p2Rq1p/2p2kp1/p3Q3/8/P6P/1P3PP1/6K1 b - - 1 41')
      end
    end
  end
end
