class Board
  attr_reader :positions

  def initialize
    @positions = (1..42).to_a
  end
end