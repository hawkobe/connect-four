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
end
