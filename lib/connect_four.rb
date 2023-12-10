# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

class ConnectFour
  attr_reader :player_one, :board, :current_player

  def initialize
    @board = Board.new
    @current_player = nil
  end

  def player_setup
    puts 'Player 1, please enter your name'.white
    player_one_name = gets.chomp
    @player_one = Player.new(player_one_name, "\u25CF".red)
    print "Thanks, #{@player_one.name}! Your symbol is".white
    puts " #{@player_one.symbol}"
    print "\n"
    puts 'Player 2, please enter your name'.white
    player_two_name = gets.chomp
    @player_two = Player.new(player_two_name, "\u25CB".yellow)
    print "Thanks, #{@player_two.name}! Your symbol is".white
    puts  " #{@player_two.symbol}"
    print "\n"

    @current_player = [@player_one, @player_two].sample
  end

  def play
    intro_message
    player_setup
    game_loop
  end

  def game_loop
    loop do
      switch_player
      puts "Alright #{@current_player.name}, it's your turn"
      puts 'This is what your board looks like'
      board.display
      break winner_message if game_won?(execute_move(board.select_column), @current_player.symbol)
      break draw_message if @board.board_full?

      print "\e[2J\e[f"
    end
  end

  def winner_message
    puts "#{@current_player.name} has won the game!"
    puts "Here's what your final board looked like"
    board.display
  end

  def draw_message
    puts 'Wow, it looks like it was a draw!'
    puts "Here's your final board"
    board.display
  end

  def intro_message
    message = <<~HEREDOC.white
      Welcome to Connect Four, the game where two players
      compete against one another to try to connect four of
      their own pieces in a row. Each player will take a turn
      dropping their pieces into a specified column -- this
      will place your piece in that column at the next
      available slot.#{' '}

      When it's your turn, just choose a number 1-7 that
      corresponds to the column where you'd like to place
      your piece. First to four in a row vertically,
      horizontally, or diagonally wins! Good Luck!
    HEREDOC
    puts message
  end

  def game_won?(position_array, symbol)
    @board.veritcal_win?(position_array, symbol) ||
      @board.horizontal_win?(position_array, symbol) ||
      @board.diag_down_left_win?(position_array, symbol) ||
      @board.diag_down_right_win?(position_array, symbol) ||
      @board.diag_up_left_win?(position_array, symbol) ||
      @board.diag_up_right_win?(position_array, symbol)
  end

  def switch_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
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
end
