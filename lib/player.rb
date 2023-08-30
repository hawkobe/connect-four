class Player

  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def select_column
    puts "Please select a column in which you would like to drop your piece"
    selected_column = gets.chomp 
  end  
end