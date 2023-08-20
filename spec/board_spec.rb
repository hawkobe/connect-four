require_relative '../lib/board.rb'

describe Board do
  
  context 'when creating an instance of board' do
    
    it 'instantiates with the correct default board' do
      board = Board.new
      board_positions = board.positions
      expect(board_positions).to eq((1..42).to_a)
    end
  end
end