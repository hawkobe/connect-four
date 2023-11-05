require_relative 'board.rb'
require_relative 'player.rb'

class ConnectFour
  attr_reader :player1, :board, :current_player

  def initialize
    @board = Board.new
    @current_player = nil
  end 

  def player_setup
    puts "Player 1, please enter your name"
    player_one_name = gets.chomp
    @player_one = Player.new(player_one_name, "\u25CF")
    puts "Thanks, #{@player_one.name}! Your symbol is #{@player_one.symbol}"

    puts "Player 2, please enter your name"
    player_two_name = gets.chomp
    @player_two = Player.new(player_two_name, "\u25CB")
    puts "Thanks, #{@player_two.name}! Your symbol is #{@player_two.symbol}"
  end

  def execute_move(column_number)
    if board.column_full?(column_number -1)
      puts 'Column has no available positions, please pick a different column'
      new_column_selection = gets.chomp
      execute_move(new_column_selection.to_i)
    else
      column_to_change = column_number - 1
      position_to_change = @board.positions[column_to_change].index('-')
      @board.positions[column_to_change][position_to_change] = @current_player.symbol
    end
  end    
end

game = ConnectFour.new
game.player_setup


# study private methods again to figure out how to not have to use attr_accessor