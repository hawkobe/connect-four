require_relative '../lib/board.rb'

describe Board do
  
  subject(:board) { described_class.new }

  context 'when creating an instance of board' do
    
    it 'instantiates with the correct default board' do
      board_positions = board.positions
      expect(board_positions).to eq(Array.new(6) {Array.new(7, nil)})
    end
  end

  describe '#board_full?' do

    context 'when the board is full' do

      before do
        board.instance_variable_set(
          :@positions, 
          board.positions.map do |row|
          row.map { |position| position = 'x' }
        end)
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
          row.each_with_index.map { |space, idx| idx % 2 == 0 ? space = "x" : space }
        end
        
        expect(board.board_full?).to be(false)
      end

      it 'returns false when all but one space are taken' do
        board.positions = board.positions.map { |row| row = ["x", "x", "x", "x", "x", "x", "x"] }
        board.positions[0][0] = nil
        expect(board.board_full?).to be(false)
      end
    end
  end
end