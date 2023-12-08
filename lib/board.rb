require 'colorize'

class Board
  attr_accessor :positions

  def initialize
    @positions = Array.new(7) { Array.new(6, '-') }
  end

  def display
    print "\n"
    puts "      1    2    3    4    5    6    7 ".white
    print "\n"
    i = 5
    while i >= 0
      if i == 5
        print "   \u2554".blue
        35.times { print "\u2550".blue}
        print "\u2557".blue
        print "\n"
      end
      print "   \u2551".blue
      @positions.each do |column|
        print "\u3016".blue
        print "#{column[i]}"
        print "\u3017".blue
      end
      print "\u2551".blue
      print "\n"
      print "   \u2560".blue unless i == 0
      35.times { print "\u2550".blue } unless i == 0
      print "\u2563".blue unless i == 0
      print "\n" unless i == 0
      i -= 1
    end
    print "   \u255A".blue
    35.times { print "\u2550".blue }
    puts "\u255D".blue
    print "   \u2551".blue
    35.times {print " "}
    puts "\u2551".blue
    print "  \u2550\u2569\u2550".blue
    33.times {print " "}
    puts "\u2550\u2569\u2550".blue
    2.times { print "\n" }
  end

  def board_full?
    @positions.none? { |row| row.include?("-") }
  end

  def column_full?(column_number)
    @positions[column_number].none?('-')
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

  def veritcal_win?(position_array, symbol)
    column = position_array[0]
    position_in_column = position_array[1]

    return false if position_in_column <= 2

    for i in 1..3
      if @positions[column][position_in_column - i] == symbol
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
        if @positions[column - i][position_in_column] == symbol
          next
        else
          return false
        end
      else
        if @positions[column + i][position_in_column] == symbol
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
      if @positions[column - i][position_in_column - i] == symbol
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
      if @positions[column + i][position_in_column - i] == symbol
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
      if @positions[column + i][position_in_column + i] == symbol
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
      if @positions[column - i][position_in_column + i] == symbol
        next
      else
        return false
      end
    end

    true
  end
end

# = Board.new

# black_marker = "\u25CB"
# white_marker = "\u25CF"

# positions[5][0] = white_marker
# positions[5][1] = black_marker

# display