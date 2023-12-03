require_relative '../lib/connect_four.rb'
require_relative '../lib/board.rb'
require 'rspec'

describe ConnectFour do

  subject(:game) { described_class.new }

  describe '#player_setup' do

    context 'when setting up players' do
      
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return("Jacob", "Crystal")
        game.player_setup
      end

      it 'sets up a player class for player 1 with the correct name' do
        player_one_name = game.instance_variable_get(:@player_one).name
        expect(player_one_name).to eq("Jacob")
      end

      it 'sets up the correct symbol for player 1' do
        player_one_symb = game.instance_variable_get(:@player_one).symbol
        expect(player_one_symb).to eq("\u25CF")
      end

      it 'sets up player class for player 2 with the correct name' do
        player_two_name = game.instance_variable_get(:@player_two).name
        expect(player_two_name).to eq("Crystal")
      end

      it 'sets up the correct symbol for player 2' do
        player_two_symb = game.instance_variable_get(:@player_two).symbol
        expect(player_two_symb).to eq("\u25CB")
      end
    end
  end

  describe '#execute_move' do

    before do
      game.instance_variable_set(:@current_player, Player.new("Jacob", "\u25CB"))
    end

    context 'when selecting a position' do

      it 'returns the correct position for an empty column' do
        player_selection = 1
        position_to_return = [0, 0]
        selected_position = game.execute_move(player_selection)
        expect(selected_position).to eq(position_to_return)
      end

      it 'returns the correct position for a column that has pieces in it' do
        player_selection = 1
        game.board.positions[0][0] = "\u25CF"
        position_to_return = [0, 1]
        selected_position = game.execute_move(player_selection)
        expect(selected_position).to eq(position_to_return)
      end
    end

    context 'when the column has open positions' do

      it 'puts the token in the correct column' do
        player_selection = 1
        expect { game.execute_move(player_selection) }.to change { game.board.positions[0] }
      end
      
      it 'puts the symbol in the correct position when column is empty' do
        player_selection = 1
        current_player_symbol = game.current_player.symbol
        game.execute_move(player_selection)
        expect(game.board.positions[0][0]).to eq(current_player_symbol)
      end

      it 'puts the symbol in the correct position when column has some symbols already' do
        player_selection = 1
        current_player_symbol = game.current_player.symbol
        opposing_player_symbol = "\u25CF"
        game.board.positions[0] = [opposing_player_symbol, opposing_player_symbol, '-', '-', '-', '-']
        game.execute_move(player_selection)
        expect(game.board.positions[0][2]).to eq(current_player_symbol)
      end
    end

    context 'when the column doesn\'t have open positions' do

      before do
        game.board.positions[0] = game.board.positions[0].map { |position| position = "\u25CF" }
        allow(game).to receive(:gets).and_return("2")
      end

      it 'doesn\'t allow the player to make a move there' do
        player_selection = 1
        expect(game).to receive(:puts).once.with('Column has no available positions, please pick a different column')
        game.execute_move(player_selection)
      end
    end
  end

  describe '#game_over?' do

  end

  describe '#veritcal_win?' do
    context 'when there are three of the same symbol in a row below it' do
      it 'correctly assigns vertical win' do
        current_player_symbol = "\u25CF"
        current_player_position = [0, 3]
        game.board.positions[0] = [current_player_symbol, current_player_symbol, current_player_symbol, '-', '-', '-']
        result = game.veritcal_win?(current_player_position, current_player_symbol)
        expect(result).to be(true)
      end
    end

    context 'when there are less than three pieces below it' do
      it 'does not assign a vertical win' do
        current_player_symbol = "\u25CF"
        current_player_position = [0, 2]
        game.board.positions[0] = [current_player_symbol, current_player_symbol, '-', '-', '-', '-']
        result = game.veritcal_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end

    context 'when there are 2 of the current players pieces and 1 opposing players piece' do
      it 'does not assign a vertical win' do
        current_player_symbol = "\u25CF"
        opposing_player_symbol = "\u25CB"
        current_player_position = [0, 3]
        game.board.positions[0] = [current_player_symbol, opposing_player_symbol, current_player_symbol, '-', '-', '-']
        result = game.veritcal_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end
  end

  describe '#horizontal_win?' do
    let(:current_player_symbol)  { "\u25CF" }
    let(:opposing_player_symbol)  { "\u25CB" }

    context 'when there are three of the player\'s pieces in a row next to the players position' do
      context 'when there are three pieces to the left' do
        it 'correctly assigns left horizontal win' do
          current_player_position = [3, 0]
          game.board.positions[0][0] = current_player_symbol
          game.board.positions[1][0] = current_player_symbol
          game.board.positions[2][0] = current_player_symbol
          result = game.horizontal_win?(current_player_position, current_player_symbol)
          expect(result).to be(true)
        end
      end

      context 'when there are three pieces to the right' do
        it 'correctly assigns right vertical win' do
          current_player_position = [0, 0]
          game.board.positions[1][0] = current_player_symbol
          game.board.positions[2][0] = current_player_symbol
          game.board.positions[3][0] = current_player_symbol
          result = game.horizontal_win?(current_player_position, current_player_symbol)
          expect(result).to be(true)
        end
      end
    end

    context 'when there are 2 correct pieces and 1 incorrect piece next to the players position' do
      it 'does not assign left horizontal win' do
        current_player_position = [3, 0]
        game.board.positions[0][0] = current_player_symbol
        game.board.positions[1][0] = opposing_player_symbol
        game.board.positions[2][0] = current_player_symbol
        result = game.horizontal_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'does not assign right horizontal win' do
        current_player_position = [0, 0]
        game.board.positions[1][0] = current_player_symbol
        game.board.positions[2][0] = opposing_player_symbol
        game.board.positions[3][0] = current_player_symbol
        result = game.horizontal_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end
  end


  describe '#diag_down_left_win?' do
    let(:current_player_symbol)  { "\u25CF" }
    let(:opposing_player_symbol)  { "\u25CB" }

    context 'when there are 3 pieces diagonally left and down from chosen position' do
      it 'correctly assigns diagonal down left win' do
        current_player_position = [3, 3]
        game.board.positions[0][0] = current_player_symbol
        game.board.positions[1][1] = current_player_symbol
        game.board.positions[2][2] = current_player_symbol
        result = game.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(true)
      end
    end

    context 'when there are two correct pieces and one opposing piece' do
      it 'does not assign a diagonal down left win' do
        current_player_position = [3, 3]
        game.board.positions[0][0] = current_player_symbol
        game.board.positions[1][1] = opposing_player_symbol
        game.board.positions[2][2] = current_player_symbol
        result = game.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end

    context 'when the chosen position is in a column less than three' do
      it 'automatically returns false in column one' do
        current_player_position = [0, 0]
        result = game.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column two' do
        current_player_position = [1, 0]
        result = game.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column three' do
        current_player_position = [2, 0]
        result = game.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column greater than 3 when position in column is less than four' do
        current_player_position = [4, 2]
        result = game.diag_down_left_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end
  end

  describe '#diag_down_right_win?' do
    
    let(:current_player_symbol)  { "\u25CF" }
    let(:opposing_player_symbol)  { "\u25CB" }

    context 'when there are 3 pieces diagonally right and down from chosen position' do
      it 'correctly assigns diagonal down right win' do
        current_player_position = [0, 3]
        game.board.positions[1][2] = current_player_symbol
        game.board.positions[2][1] = current_player_symbol
        game.board.positions[3][0] = current_player_symbol
        result = game.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(true)
      end
    end

    context 'when there are two correct pieces and one opposing piece' do
      it 'does not assign a diagonal down right win' do
        current_player_position = [0, 3]
        game.board.positions[1][2] = current_player_symbol
        game.board.positions[2][1] = opposing_player_symbol
        game.board.positions[3][0] = current_player_symbol
        result = game.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end

    context 'when the chosen position is in a column greater than four' do
      it 'automatically returns false in column five' do
        current_player_position = [4, 0]
        result = game.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column six' do
        current_player_position = [5, 0]
        result = game.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column seven' do
        current_player_position = [6, 0]
        result = game.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end

      it 'automatically returns false in column four or less when position in column is greater than four' do
        current_player_position = [3, 4]
        result = game.diag_down_right_win?(current_player_position, current_player_symbol)
        expect(result).to be(false)
      end
    end

    describe '#diag_up_right_win?' do
      let(:current_player_symbol)  { "\u25CF" }
      let(:opposing_player_symbol)  { "\u25CB" }
  
      context 'when there are 3 pieces diagonally right and up from chosen position' do
        it 'correctly assigns diagonal up right win' do
          current_player_position = [0, 0]
          game.board.positions[1][1] = current_player_symbol
          game.board.positions[2][2] = current_player_symbol
          game.board.positions[3][3] = current_player_symbol
          result = game.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(true)
        end
      end
  
      context 'when there are two correct pieces and one opposing piece' do
        it 'does not assign a diagonal up right win' do
          current_player_position = [0, 3]
          game.board.positions[1][1] = current_player_symbol
          game.board.positions[2][2] = opposing_player_symbol
          game.board.positions[3][3] = current_player_symbol
          result = game.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
      end
  
      context 'when the chosen position is in a column more than four' do
        it 'automatically returns false in column five' do
          current_player_position = [4, 0]
          result = game.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
  
        it 'automatically returns false in column six' do
          current_player_position = [5, 0]
          result = game.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
  
        it 'automatically returns false in column seven' do
          current_player_position = [6, 0]
          result = game.diag_up_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end

        it 'automatically returns false if column is four or less but position in column is greater than four' do
          current_player_position = [3, 3]
          result = game.diag_down_right_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
      end
    end

    describe '#diag_up_left_win?' do
      let(:current_player_symbol)  { "\u25CF" }
      let(:opposing_player_symbol)  { "\u25CB" }
  
      context 'when there are 3 pieces diagonally left and up from chosen position' do
        it 'correctly assigns diagonal up left win' do
          current_player_position = [3, 0]
          game.board.positions[2][1] = current_player_symbol
          game.board.positions[1][2] = current_player_symbol
          game.board.positions[0][3] = current_player_symbol
          result = game.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(true)
        end
      end
  
      context 'when there are two correct pieces and one opposing piece' do
        it 'does not assign a diagonal up left win' do
          current_player_position = [3, 0]
          game.board.positions[2][1] = current_player_symbol
          game.board.positions[1][2] = opposing_player_symbol
          game.board.positions[0][3] = current_player_symbol
          result = game.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
      end
  
      context 'when the chosen position is in a column less than three' do
        it 'automatically returns false in column one' do
          current_player_position = [0, 0]
          result = game.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
  
        it 'automatically returns false in column two' do
          current_player_position = [1, 0]
          result = game.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
  
        it 'automatically returns false in column three' do
          current_player_position = [2, 0]
          result = game.diag_up_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
  
        it 'automatically returns false in column three or less when position in column is greater than three' do
          current_player_position = [1, 4]
          result = game.diag_down_left_win?(current_player_position, current_player_symbol)
          expect(result).to be(false)
        end
      end
    end
  end

  describe 'game_over?' do
    
    it 'returns true when vertical win' do
      current_player_symbol = "\u25CF"
      current_player_position = [0, 3]
      game.board.positions[0] = [current_player_symbol, '-', current_player_symbol, '-', '-', '-']
      result = game.game_over?(current_player_position, current_player_symbol)
      expect(result).to be(false)
    end
  end
  describe '#update_board' do
    # will need to update the board after each move is executed
  end
end
