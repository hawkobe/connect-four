class Board
  attr_accessor :positions

  def initialize
    @positions = Array.new(6) { Array.new(7, nil) }
  end

  def display
    print "\n"
    @positions.each do |row|
      print "   "
      29.times { print "-" }
      print "\n"
      print "   | "
      row.each do |space|
        print "#{space}  | "
      end
      print "\n"
    end
    print "   "
    29.times { print "=" }
    print "\n"
    puts "   | 1 | 2 | 3 | 4 | 5 | 6 | 7 |"
    2.times { print "\n" }
  end

  def board_full?
    @positions.none? { |row| row.include?(nil) }
  end
end