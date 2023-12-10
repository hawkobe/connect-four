# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  context 'when creating an instance of board' do
    it 'instantiates with the correct default board' do
      board_positions = board.positions
      expect(board_positions).to eq(Array.new(7) { Array.new(6, '-') })
    end
  end

  describe '#board_full?' do
    context 'when the board is full' do
      before do
        board.instance_variable_set(
          :@positions,
          board.positions.map do |row|
            row.map { |_position| position = 'x' }
          end
        )
      end

      it 'returns true' do
        expect(board.board_full?).to be(true)
      end
    end

    context 'when the board is not not full' do
      it 'returns false when completely empty' do
        expect(board.board_full?).to be(false)
      end

      it 'returns false when some positions are full' do
        board.positions = board.positions.map do |row|
          row.each_with_index.map { |space, idx| idx.even? ? space = 'x' : space }
        end

        expect(board.board_full?).to be(false)
      end

      it 'returns false when all but one space are taken' do
        board.positions = board.positions.map { |_column| column = %w[x x x x x x x] }
        board.positions[0][0] = '-'
        expect(board.board_full?).to be(false)
      end
    end
  end

  describe '#column_full?' do
    context 'when the row is full' do
      before do
        board.positions = board.positions.map { |column| column.map { |_position| position = 'x' } }
      end

      it 'returns true for selected row' do
        outputted_response = board.column_full?(0)
        expect(outputted_response).to be(true)
      end

      it 'works for every column' do
        outputted_response = board.column_full?(4)
        expect(outputted_response).to be(true)
      end
    end

    context 'when the column is not full' do
      it 'returns false when totally empty' do
        outputted_response = board.column_full?(0)
        expect(outputted_response).to be(false)
      end

      it 'returns false when partially full' do
        board.positions[1] = ['x', 'x', '-', 'x', '-', '-', 'x']
        outputted_response = board.column_full?(1)
        expect(outputted_response).to be(false)
      end
    end
  end

  describe '#veritcal_win?' do
    context 'when there are three of the same symbol in a row below it' do
      it 'correctly assigns vertical win' do
        current_player_symbol = "\u25CF"
        current_player_position = [0, 3]
        board.positions[0] = [current_player_symbol, current_player_symbol, current_player_symbol, '-', '-', '-']
        result = board.veritcal_win?(current_player_position, current_player_symbol)
        expect(result).to be(true)
      end
    end

    context 'when there are less than three pieces below it' do
      it 'does not assign a vertical win' do
        current_player_symbol = "\u25CF"
        current_player_position = [0, 2]
        board.positions[0] = [current_player_symbol, current_player_symbol, '-', '-', '-', '-']
        result = board.veritcal_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end

    context 'when there are 2 of the current players pieces and 1 opposing players piece' do
      it 'does not assign a vertical win' do
        current_player_symbol = "\u25CF"
        opposing_player_symbol = "\u25CB"
        current_player_position = [0, 3]
        board.positions[0] = [current_player_symbol, opposing_player_symbol, current_player_symbol, '-', '-', '-']
        result = board.veritcal_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end
  end

  describe '#horizontal_win?' do
    let(:current_player_symbol) { "\u25CF" }
    let(:opposing_player_symbol)  { "\u25CB" }

    context 'when there are three of the player\'s pieces in a row next to the players position' do
      context 'when there are three pieces to the left' do
        it 'correctly assigns left horizontal win' do
          current_player_position = [3, 0]
          board.positions[0][0] = current_player_symbol
          board.positions[1][0] = current_player_symbol
          board.positions[2][0] = current_player_symbol
          result = board.horizontal_win?(current_player_position, current_player_symbol)
          expect(result).to be(true)
        end
      end

      context 'when there are three pieces to the right' do
        it 'correctly assigns right vertical win' do
          current_player_position = [0, 0]
          board.positions[1][0] = current_player_symbol
          board.positions[2][0] = current_player_symbol
          board.positions[3][0] = current_player_symbol
          result = board.horizontal_win?(current_player_position, current_player_symbol)
          expect(result).to be(true)
        end
      end
    end

    context 'when there are 2 correct pieces and 1 incorrect piece next to the players position' do
      it 'does not assign left horizontal win' do
        current_player_position = [3, 0]
        board.positions[0][0] = current_player_symbol
        board.positions[1][0] = opposing_player_symbol
        board.positions[2][0] = current_player_symbol
        result = board.horizontal_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'does not assign right horizontal win' do
        current_player_position = [0, 0]
        board.positions[1][0] = current_player_symbol
        board.positions[2][0] = opposing_player_symbol
        board.positions[3][0] = current_player_symbol
        result = board.horizontal_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end
  end

  describe '#diag_down_left_win?' do
    let(:current_player_symbol) { "\u25CF" }
    let(:opposing_player_symbol) { "\u25CB" }

    context 'when there are 3 pieces diagonally left and down from chosen position' do
      it 'correctly assigns diagonal down left win' do
        current_player_position = [3, 3]
        board.positions[0][0] = current_player_symbol
        board.positions[1][1] = current_player_symbol
        board.positions[2][2] = current_player_symbol
        result = board.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(true)
      end
    end

    context 'when there are two correct pieces and one opposing piece' do
      it 'does not assign a diagonal down left win' do
        current_player_position = [3, 3]
        board.positions[0][0] = current_player_symbol
        board.positions[1][1] = opposing_player_symbol
        board.positions[2][2] = current_player_symbol
        result = board.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end

    context 'when the chosen position is in a column less than three' do
      it 'automatically returns false in column one' do
        current_player_position = [0, 0]
        result = board.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column two' do
        current_player_position = [1, 0]
        result = board.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column three' do
        current_player_position = [2, 0]
        result = board.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column greater than 3 when position in column is less than four' do
        current_player_position = [4, 2]
        result = board.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end
  end

  describe '#diag_down_right_win?' do
    let(:current_player_symbol) { "\u25CF" }
    let(:opposing_player_symbol) { "\u25CB" }

    context 'when there are 3 pieces diagonally right and down from chosen position' do
      it 'correctly assigns diagonal down right win' do
        current_player_position = [0, 3]
        board.positions[1][2] = current_player_symbol
        board.positions[2][1] = current_player_symbol
        board.positions[3][0] = current_player_symbol
        result = board.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(true)
      end
    end

    context 'when there are two correct pieces and one opposing piece' do
      it 'does not assign a diagonal down right win' do
        current_player_position = [0, 3]
        board.positions[1][2] = current_player_symbol
        board.positions[2][1] = opposing_player_symbol
        board.positions[3][0] = current_player_symbol
        result = board.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end

    context 'when the chosen position is in a column greater than four' do
      it 'automatically returns false in column five' do
        current_player_position = [4, 0]
        result = board.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column six' do
        current_player_position = [5, 0]
        result = board.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column seven' do
        current_player_position = [6, 0]
        result = board.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column four or less when position in column is greater than four' do
        current_player_position = [3, 4]
        result = board.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end

    describe '#diag_up_right_win?' do
      let(:current_player_symbol)  { "\u25CF" }
      let(:opposing_player_symbol) { "\u25CB" }

      context 'when there are 3 pieces diagonally right and up from chosen position' do
        it 'correctly assigns diagonal up right win' do
          current_player_position = [0, 0]
          board.positions[1][1] = current_player_symbol
          board.positions[2][2] = current_player_symbol
          board.positions[3][3] = current_player_symbol
          result = board.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(true)
        end
      end

      context 'when there are two correct pieces and one opposing piece' do
        it 'does not assign a diagonal up right win' do
          current_player_position = [0, 3]
          board.positions[1][1] = current_player_symbol
          board.positions[2][2] = opposing_player_symbol
          board.positions[3][3] = current_player_symbol
          result = board.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
      end

      context 'when the chosen position is in a column more than four' do
        it 'automatically returns false in column five' do
          current_player_position = [4, 0]
          result = board.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end

        it 'automatically returns false in column six' do
          current_player_position = [5, 0]
          result = board.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end

        it 'automatically returns false in column seven' do
          current_player_position = [6, 0]
          result = board.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end

        it 'automatically returns false if column is four or less but position in column is greater than four' do
          current_player_position = [3, 3]
          result = board.diag_down_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
      end
    end

    describe '#diag_up_left_win?' do
      let(:current_player_symbol) { "\u25CF" }
      let(:opposing_player_symbol) { "\u25CB" }

      context 'when there are 3 pieces diagonally left and up from chosen position' do
        it 'correctly assigns diagonal up left win' do
          current_player_position = [3, 0]
          board.positions[2][1] = current_player_symbol
          board.positions[1][2] = current_player_symbol
          board.positions[0][3] = current_player_symbol
          result = board.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(true)
        end
      end

      context 'when there are two correct pieces and one opposing piece' do
        it 'does not assign a diagonal up left win' do
          current_player_position = [3, 0]
          board.positions[2][1] = current_player_symbol
          board.positions[1][2] = opposing_player_symbol
          board.positions[0][3] = current_player_symbol
          result = board.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
      end

      context 'when the chosen position is in a column less than three' do
        it 'automatically returns false in column one' do
          current_player_position = [0, 0]
          result = board.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end

        it 'automatically returns false in column two' do
          current_player_position = [1, 0]
          result = board.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end

        it 'automatically returns false in column three' do
          current_player_position = [2, 0]
          result = board.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end

        it 'automatically returns false in column three or less when position in column is greater than three' do
          current_player_position = [1, 4]
          result = board.diag_down_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
      end
    end
  end
end
