require_relative '../lib/connect_four.rb'
require_relative '../lib/board.rb'

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
    # needs to take #column_full from board class with select_column as arg
    # and then execute if position available
    # board.column_full?(@current_player.select_column - 1)
    before do
      game.instance_variable_set(:@current_player, Player.new("Jacob", "\u25CB"))
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
        game.board.positions[0] = [opposing_player_symbol, opposing_player_symbol, '-', '-', '-', '-', '-']
        game.execute_move(player_selection)
        expect(game.board.positions[0][2]).to eq(current_player_symbol)
      end
    end
  end

  describe '#game_over?' do
    # will probably need to utilize a search graph of some sort
    # after each move is executed
  end

  describe '#update_board' do
    # will need to update the board after each move is executed
  end
end
