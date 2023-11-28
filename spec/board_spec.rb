require_relative '../lib/board.rb'

describe Board do
  
  subject(:board) { described_class.new }

  context 'when creating an instance of board' do
    
    it 'instantiates with the correct default board' do
      board_positions = board.positions
      expect(board_positions).to eq(Array.new(7) {Array.new(6, '-')})
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
        board.positions = board.positions.map { |column| column = ["x", "x", "x", "x", "x", "x", "x"] }
        board.positions[0][0] = '-'
        expect(board.board_full?).to be(false)
      end
    end
  end

  describe '#column_full?' do

    context 'when the row is full' do

      before do
        board.positions = board.positions.map { |column| column.map { |position| position = "x" } }
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
end