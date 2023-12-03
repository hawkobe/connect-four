require_relative 'board.rb'
require_relative 'player.rb'

class ConnectFour
  attr_reader :player_one, :board, :current_player

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

  # def play
  #   until game_over?
  #   end
  # end

  def game_over?(position_array, symbol)
    veritcal_win?(position_array, symbol) || 
    horizontal_win?(position_array, symbol) || 
    diag_down_left_win?(position_array, symbol) || 
    diag_down_right_win?(position_array, symbol) || 
    diag_up_left_win?(position_array, symbol) || 
    diag_up_right_win?(position_array, symbol) ||
    board.board_full?
  end

  def execute_move(column_number)
    if board.column_full?(column_number - 1)
      puts 'Column has no available positions, please pick a different column'
      new_column_selection = gets.chomp
      execute_move(new_column_selection.to_i)
    else
      column_to_change = column_number - 1
      position_to_change = @board.positions[column_to_change].index('-')
      @board.positions[column_to_change][position_to_change] = @current_player.symbol
      [column_to_change, position_to_change]
    end
  end

  def veritcal_win?(position_array, symbol)
    column = position_array[0]
    position_in_column = position_array[1]

    return false if position_in_column <= 2

    for i in 1..3
      if @board.positions[column][position_in_column - i] == symbol
        next
      else
        return false
      end
    end

    true
  end

  def horizontal_win?(position_array, symbol)
    column = position_array[0]
    position_in_column = position_array[1]

    for i in 1..3
      if column > 2
        if @board.positions[column - i][position_in_column] == symbol
          next
        else
          return false
        end
      else
        if @board.positions[column + i][position_in_column] == symbol
          next
        else
          return false
        end
      end
    end

    true
  end

  def diag_down_left_win?(position_array, symbol)
    column = position_array[0]
    position_in_column = position_array[1]

    return false if column < 3 || position_in_column < 3

    for i in 1..3
      if @board.positions[column - i][position_in_column - i] == symbol
        next
      else
        return false
      end
    end

    true
  end

  def diag_down_right_win?(position_array, symbol)
    column = position_array[0]
    position_in_column = position_array[1]

    return false if column > 3 || position_in_column < 3

    for i in 1..3
      if @board.positions[column + i][position_in_column - i] == symbol
        next
      else
        return false
      end
    end

    true
  end

  def diag_up_right_win?(position_array, symbol)
    column = position_array[0]
    position_in_column = position_array[1]

    return false if column > 3 || position_in_column > 3

    for i in 1..3
      if @board.positions[column + i][position_in_column + i] == symbol
        next
      else
        return false
      end
    end

    true
  end

  def diag_up_left_win?(position_array, symbol)
    column = position_array[0]
    position_in_column = position_array[1]

    return false if column < 3 || position_in_column > 3

    for i in 1..3
      if @board.positions[column - i][position_in_column + i] == symbol
        next
      else
        return false
      end
    end

    true
  end
end

# game = ConnectFour.new
# game.instance_variable_set(:@current_player, Player.new("Jacob", "\u25CF"))

# game.execute_move(1)
# game.board.display

# study private methods again to figure out how to not have to use attr_accessor