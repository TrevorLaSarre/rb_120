module Drawable
  def draw
    update_numbers_display
    
    n = Integer.sqrt(self.numbers.size)
    x = 0
    
    n.times do |y|
      n.times do |z|
        print "#{spaces(self.numbers[x + z])}"
        print z < (n - 1) ? "|" : "\n"
      end
      n.times do |z|
        print "   #{self.squares[x + z + 1]}   "
        print z < (n - 1) ? "|" : "\n"
      end
      n.times do |z|
        print z < (n - 1) ? "       |" : "\n"
      end
      n.times do |z|
        unless y == (n - 1)
          print "-------"
          print z < (n - 1) ? "+" : "\n"
        end
      end
      x += n
    end
  end
  
  def update_numbers_display
    self.numbers.map! do |num|
      if num.class == Integer && self.squares[num].marked?
        num = ' '
      end
      num
    end
  end
  
  def spaces(num)
    case num.to_i.digits.size
    when 1 then "   #{num}   "
    when 2 then "   #{num}  "
    when 3 then "  #{num}  "
    when 4 then "  #{num} "
    end
  end
end

module Winnable
  def horizontal_winners
    n = Integer.sqrt(self.numbers.size)
    left = (n - 1)
    horizontal = []
  
    n.times do |x|
      horizontal << numbers[(x * n)..(n * x + left)]
    end
      
    horizontal
  end
  
  def vertical_winners
    n = Integer.sqrt(self.numbers.size)
    vertical = []
  
    n.times do |x|
      line = []
      n.times { |y| line << numbers[x + (y * n)] }
      vertical << line
    end
    
    vertical
  end
  
  def diagonal_winners
    n = Integer.sqrt(self.numbers.size)
    diagonals = []
    right = (n + 1)
    left = (n - 1)
  
    n.times { |x| diagonals << numbers[x * right] }
    n.times { |x| diagonals << numbers[left + (left * x)] }
    [diagonals[0..left], diagonals[n..-1]]
  end
  
  def all_winners
    horizontal_winners + vertical_winners + diagonal_winners 
  end
  
  def someone_won?
    !!winning_marker
  end
  
  def winning_marker
    self.winning_lines.each do |line|
      squares = self.squares.values_at(*line)
      if line_of_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end
  
  def line_of_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != squares.size
    markers.min == markers.max
  end
end

module Readable
  def threat(player_marker)
    self.winning_lines.each do |line|
      next unless line.none? { |x| self.squares[x].marker == player_marker } &&
                  line.count { |x| self.squares[x].unmarked? } == 1
      return      line.select { |x| self.squares[x].unmarked? }.pop
    end
    nil
  end

  def opportunity(player_marker)
    self.winning_lines.each do |line|
      next unless line.count { |x| self.squares[x].marker == player_marker } == (line.size - 1) &&
                  line.count { |x| self.squares[x].unmarked? } == 1
      return      line.select { |x| self.squares[x].unmarked? }.pop
    end
    nil
  end
end

class Board
  include Drawable, Winnable, Readable
  attr_accessor :squares, :numbers
  attr_reader :winning_lines

  def initialize(size=3)
    @squares = {}
    reset(size)
    @winning_lines = all_winners
  end
  
  def reset(x)
    @numbers = (1..x**2).to_a
    @numbers.each { |x| @squares[x] = Square.new }
  end

  def[]=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end
  
  def width
    Integer.sqrt(numbers.size) * 8
  end
  
  def middle
    @middle = (numbers.size / 2) + 1
  end

  def full?
    unmarked_keys.empty?
  end
end

class Square
  INITIAL_MARKER = ' '
  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :score, :marker
  attr_reader :name

  def initialize
    @name = set_name
    @marker = set_marker
    @score = 0
  end

  def same_marker?(other_player)
    marker == other_player.marker
  end
end

class Computer < Player
  NAMES = ['The Aluminum Monster', 'Mac', 'Artemis'] +
          ['Rickety Cricket', 'The Nightman']
  MARKERS = ['O', 'X', '$', '&', '*']

  def set_marker
    @marker = MARKERS.sample
  end

  def set_name
    NAMES.sample
  end

  def moves(board)
    if detect_opportunity?(board)
      offensive_move(board)
    elsif detect_threat?(board)
      defensive_move(board)
    elsif board.unmarked_keys.include?(board.middle)
      board[board.middle] = marker
    else
      board[board.unmarked_keys.sample] = marker
    end
  end

  private

  def defensive_move(board)
    board[board.threat(marker)] = marker
  end

  def offensive_move(board)
    board[board.opportunity(marker)] = marker
  end

  def detect_opportunity?(board)
    !!board.opportunity(marker)
  end

  def detect_threat?(board)
    !!board.threat(marker)
  end
end

class Human < Player
  def set_name
    puts "Before we get started, what's your name?"
    answer = gets.chomp
    answer
  end

  def set_marker
    system 'clear'
    answer = nil
    puts "Hi #{name}! Please enter any character to use as your board marker: "
    loop do
      answer = gets.chomp
      break if answer.size == 1
      invalid_marker
    end

    self.marker = answer
  end

  def invalid_marker
    system 'clear'
    puts "Your marker must be a single character and can't be a blank space"
    puts ""
    puts "Please enter any character to use as your board marker: "
  end

  def moves(board)
    print "Choose an open square: "
    square = nil
    loop do
      square = gets.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice"
    end

    board[square] = marker
  end
end

module Displayable
  def clear
    system "clear"
  end

  def display_winner
    winner = human.score >= self.class::ROUNDS_PER_GAME ? 'You' : computer.name
    puts "#{winner} won the game!"
    puts ""
  end
  
  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
  
  def display_goodbye_message
    clear
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "#{human.name}: #{human.score}. "\
    "#{computer.name}: #{computer.score}.".center(board.width)
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end
  
  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts 'You won!'
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts 'The board is full!'
    end
    puts ""
  end
  
  def introduce_players
    clear
    puts "#{human.name}, you'll be playing this game against #{computer.name}"
    puts ""
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe! The first player to win"\
         " #{self.class::ROUNDS_PER_GAME} rounds wins the game!"
    puts ""
  end
end

class TTTGame
  ROUNDS_PER_GAME = 5
  
  include Displayable
  attr_accessor :board
  attr_reader :human, :computer
  
  def initialize
    @board = Board.new
  end

  def play
    clear
    display_welcome_message
    initialize_human
    main_game_loop
    display_goodbye_message
  end

  private

  def initialize_human
    @human = Human.new
    confirm_marker(@human)
  end

  def main_game_loop
    loop do
      define_parameters
      play_rounds
      reset
      display_winner if game_over?
      break unless play_again?
      reset_scores
      display_play_again_message
    end
  end

  def define_parameters
    initialize_computer
    set_board_size(board_size)
    introduce_players
    first_to_move
    set_current_player
  end

  def play_rounds
    loop do
      display_board
      player_move
      update_score
      display_result
      break unless !game_over? && play_again?('round')
      reset
    end
  end

  def reset
    set_board_size(@board_size)
    set_current_player
    clear
  end

  def game_over?
    computer.score == ROUNDS_PER_GAME || human.score == ROUNDS_PER_GAME
  end

  def play_again?(type = 'game')
    answer = nil
    loop do
      puts play_again_prompt(type)
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      clear
      puts "Sorry -- must answer y or n"
      puts ""
    end

    answer == 'y'
  end

  def reset_scores
    human.score = 0
    computer.score = 0
    clear
  end

  def initialize_computer
    @computer = Computer.new
    confirm_marker(@computer)
  end

  # rubocop:disable Metrics/MethodLength
  def board_size
    clear
    size = nil
    loop do
      puts "What size board would you like to play on?"
      puts ""
      puts " >> 1) 3 x 3 board (Three in a row to win)"
      puts " >> 2) 5 x 5 board (Five in a row to win)"
      puts " >> 3) 9 x 9 board (Nine in a row to win)"
      size = gets.chomp.to_i
      break if [1, 2, 3].include?(size)
      clear
      puts "I'm sorry -- you must pick 1, 2, or 3"
      puts ""
    end

    @board_size = size
  end
  
  def set_board_size(size)
    @board = case size
                  when 1 then Board.new(3)
                  when 2 then Board.new(5)
                  when 3 then Board.new(9)
                  end
  end

  def whos_first
    answer = nil
    loop do
      puts "Who would you like to make the first move?"
      puts ""
      puts " >> 1) I'd like to go first"
      puts " >> 2) I'd like #{computer.name} to go first"
      puts " >> 3) I want #{computer.name} to decide!"
      answer = gets.chomp
      break if ['1', '2', '3'].include?(answer)
      clear
      puts "I'm sorry -- you must pick 1, 2, or 3"
      puts ""
    end

    answer
  end
  # rubocop:enable Metrics/MethodLength

  def confirm_marker(player)
    while overlapping_markers?(player)
      player.set_marker
    end
  end

  def overlapping_markers?(player)
    case player
    when computer
      computer.marker == human.marker
    when human
      human.marker == board.squares[1].marker
    end
  end

  def first_to_move
    @first_to_move = case whos_first
                     when '1' then human.marker
                     when '2' then computer.marker
                     when '3' then [human.marker, computer.marker].sample
                     end
    clear
  end

  def set_current_player
    @current_player = @first_to_move
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def update_score
    case board.winning_marker
    when human.marker    then human.score += 1
    when computer.marker then computer.score += 1
    end
  end

  def current_player_moves
    if human_turn?
      human.moves(@board)
      @current_player = computer.marker
    else
      computer.moves(@board)
      @current_player = human.marker
    end
  end

  def human_turn?
    @current_player == human.marker
  end

  def play_again?(type = 'game')
    answer = nil
    loop do
      puts play_again_prompt(type)
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      clear
      puts "Sorry -- must answer y or n"
      puts ""
    end

    answer == 'y'
  end

  def play_again_prompt(type)
    if type == 'game'
      "Would you like to play a new game? (y/n)"
    else
      "Ready for the next round? (y/n)"
    end
  end
end

game = TTTGame.new
game.play
