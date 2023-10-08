class Board
  attr_accessor :positions

  def initialize
    @positions = Array.new(6) { Array.new(7, '-') }
  end

  def display
    print "\n"
    puts "     1    2    3    4    5    6    7 "
    print "\n"
    @positions.each_with_index do |row, idx|
      print "  "

      if idx == 0
        print "\u2554"
      else
        print "\u2560"
      end

      35.times { print "\u2550" }

      if idx == 0
        print "\u2557"
      else
        print "\u2563"
      end

      print "\n"
      print "  \u2551\u3016"

      row.each_with_index do |space, idx|
        if idx == 6
          print "#{space}\u3017\u2551"
        else
          print "#{space}\u3017\u3016"
        end
      end
      print "\n"
    end
    print "  \u255A"
    35.times { print "\u2550" }
    puts "\u255D"
    print "  \u2551"
    35.times {print " "}
    puts "\u2551"
    print " \u2550\u2569\u2550"
    33.times {print " "}
    puts "\u2550\u2569\u2550"
    2.times { print "\n" }
  end

  def board_full?
    @positions.none? { |row| row.include?("-") }
  end

  def column_full?(column_number)
    @positions[column_number].none?('-')
  end
end

board = Board.new

white_marker = "\u25CB"
black_marker = "\u25CF"

board.positions[5][0] = white_marker
board.positions[5][1] = black_marker

board.display