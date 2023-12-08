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
        expect(player_one_symb).to eq("\u25CF".red)
      end

      it 'sets up player class for player 2 with the correct name' do
        player_two_name = game.instance_variable_get(:@player_two).name
        expect(player_two_name).to eq("Crystal")
      end

      it 'sets up the correct symbol for player 2' do
        player_two_symb = game.instance_variable_get(:@player_two).symbol
        expect(player_two_symb).to eq("\u25CB".yellow)
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

  describe '#update_board' do
    # will need to update the board after each move is executed
  end
end
