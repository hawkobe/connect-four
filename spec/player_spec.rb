require_relative '../lib/player.rb'

describe Player do

  subject(:player) { described_class.new("Jacob") }

  context 'when instantiating class' do

    it 'instantiates with the correct name' do
      expect(player.name).to eq("Jacob")
    end

    it 'doesn\'t instantiate with a different name' do
      expect(player.name).not_to eq("Something else")
    end
  end
end