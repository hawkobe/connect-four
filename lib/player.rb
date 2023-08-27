class Player

  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

jacob = Player.new("Jacob", "\u26AB")

puts jacob.symbol