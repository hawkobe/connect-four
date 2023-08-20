class Board
  attr_accessor :positions

  def initialize
    @positions = (1..42).to_a
  end
end