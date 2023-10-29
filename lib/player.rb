class Player

  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def select_column
    puts "Please select a column in which you would like to drop your piece"
    regex = /^[1-7]$/
    selected_column = gets.chomp 
    until regex.match? selected_column
      puts "#{selected_column} is an invalid input (Please select a number 1-7)"
      selected_column = gets.chomp
    end
    selected_column.to_i
  end
end