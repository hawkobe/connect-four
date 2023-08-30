require_relative '../lib/player.rb'

describe Player do

  subject(:player) { described_class.new("Jacob", "\u25CB") }

  context 'when instantiating class' do

    it 'instantiates with the correct name' do
      expect(player.name).to eq("Jacob")
    end

    it 'doesn\'t instantiate with a different name' do
      expect(player.name).not_to eq("Something else")
    end
  end

  describe '#select_column' do

    context 'when selecting a column to drop a piece into' do

      before do
        allow(player).to receive(:puts)
        allow(player).to receive(:gets).and_return("3")
      end

      it 'returns the correct column' do
        expected_return_value = "3"
        actual_return_value = player.select_column
        expect(actual_return_value).to eq(expected_return_value)
      end
    end
  end
end