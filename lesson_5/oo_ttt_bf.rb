class Board
  attr_reader :squares

  def initialize
    @squares = {}
  end

  def[]=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def update_numbers_display(numbers)
    numbers.map! do |num|
      if num.class == Integer && @squares[num].marked?
        num = ' '
      end
      num
    end
  end

  def winning_marker(winning_lines)
    winning_lines.each do |line|
      squares = @squares.values_at(*line)
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

  def threat(winning_lines, player_marker)
    winning_lines.each do |line|
      next unless line.none? { |x| @squares[x].marker == player_marker } &&
                  line.count { |x| @squares[x].unmarked? } == 1
      return      line.select { |x| @squares[x].unmarked? }.pop
    end
    nil
  end

  def opportunity(winning_lines, player)
    winning_lines.each do |line|
      next unless
        line.count { |x| @squares[x].marker == player } == (line.size - 1) &&
        line.count { |x| @squares[x].unmarked? } == 1
      return line.select { |x| @squares[x].unmarked? }.pop
    end
    nil
  end
  
  def spaces(num)
    num.to_i.digits.size == 1 ? "   #{num}   " : "   #{num}  "
  end
end

class ThreeByThree < Board
  attr_reader :width, :middle, :numbers

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    update_numbers_display(numbers)
    puts "  #{@numbers[0]}  |  #{@numbers[1]}  |  #{@numbers[2]}"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "  #{@numbers[3]}  |  #{@numbers[4]}  |  #{@numbers[5]}"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "  #{@numbers[6]}  |  #{@numbers[7]}  |  #{@numbers[8]}"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def initialize
    super
    reset
    @width = 17
    @middle = (numbers.size / 2) + 1
  end

  def reset
    @numbers = (1..9).to_a
    @numbers.each { |x| @squares[x] = Square.new }
  end

  def winning_marker
    super(WINNING_LINES)
  end

  def threat(player_marker)
    super(WINNING_LINES, player_marker)
  end

  def opportunity(player_marker)
    super(WINNING_LINES, player_marker)
  end
end

class FiveByFive < Board
  attr_reader :width, :middle, :numbers

  WINNING_LINES =
    [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12, 13, 14, 15],
     [16, 17, 18, 19, 20], [20, 21, 22, 23, 24, 25],
     [1, 6, 11, 16, 21], [2, 7, 12, 17, 22], [3, 8, 13, 18, 23],
     [4, 9, 14, 19, 24], [5, 10, 15, 20, 25],
     [1, 7, 13, 19, 25], [5, 9, 13, 17, 21]]

  def initialize
    super
    reset
    @width = 39
    @middle = (numbers.size / 2) + 1
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    update_numbers_display(@numbers)
    x = 0

    5.times do |y|
      puts "#{spaces(@numbers[x + 0])}|#{spaces(@numbers[x + 1])}|"\
           "#{spaces(@numbers[x + 2])}|#{spaces(@numbers[x + 3])}|"\
           "#{spaces(@numbers[x + 4])}"
      puts "   #{@squares[x + 1]}   |   #{@squares[x + 2]}   |"\
           "   #{@squares[x + 3]}   |   #{@squares[x + 4]}   |"\
           "   #{@squares[x + 5]}   "
      puts "       |       |       |       |"
      puts "-------+-------+-------+-------+-------" unless y == 4
      x += 5
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def reset
    @numbers = (1..25).to_a
    @numbers.each { |x| @squares[x] = Square.new }
  end

  def winning_marker
    super(WINNING_LINES)
  end

  def threat(player_marker)
    super(WINNING_LINES, player_marker)
  end

  def opportunity(player_marker)
    super(WINNING_LINES, player_marker)
  end
end

class NineByNine < Board
  attr_reader :width, :middle, :numbers

  WINNING_LINES =
    [[1, 2, 3, 4, 5, 6, 7, 8, 9],
     [10, 11, 12, 13, 14, 15, 16, 17, 18], [19, 20, 21, 22, 23, 24, 25, 26, 27],
     [28, 29, 30, 31, 32, 33, 34, 35, 36], [37, 38, 39, 40, 41, 42, 43, 44, 45],
     [46, 47, 48, 49, 50, 51, 52, 53, 54], [55, 56, 57, 58, 59, 60, 61, 62, 63],
     [64, 65, 66, 67, 68, 69, 70, 71, 72], [73, 74, 75, 76, 77, 78, 79, 80, 81],
     [1, 10, 19, 28, 37, 46, 55, 64, 73], [2, 11, 20, 29, 38, 47, 56, 65, 74],
     [3, 12, 21, 30, 39, 48, 57, 66, 75], [4, 13, 22, 31, 40, 49, 58, 67, 76],
     [5, 14, 23, 32, 41, 50, 59, 68, 77], [6, 15, 24, 33, 42, 51, 60, 69, 78],
     [7, 16, 25, 34, 43, 52, 61, 70, 79], [8, 17, 26, 35, 44, 53, 62, 71, 80],
     [9, 18, 27, 36, 45, 54, 63, 72, 81], [1, 11, 21, 31, 41, 51, 61, 71, 81],
     [9, 17, 25, 33, 41, 49, 57, 65, 73]]

  def initialize
    super
    reset
    @width = 71
    @middle = (numbers.size / 2) + 1
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    update_numbers_display(numbers)
    x = 0

    9.times do |y|
      puts "#{spaces(@numbers[x + 0])}|#{spaces(@numbers[x + 1])}|"\
           "#{spaces(@numbers[x + 2])}|#{spaces(@numbers[x + 3])}|"\
           "#{spaces(@numbers[x + 4])}|#{spaces(@numbers[x + 5])}|"\
           "#{spaces(@numbers[x + 6])}|#{spaces(@numbers[x + 7])}|"\
           "#{spaces(@numbers[x + 8])}"
      puts "   #{@squares[x + 1]}   |   #{@squares[x + 2]}   |"\
           "   #{@squares[x + 3]}   |   #{@squares[x + 4]}   |"\
           "   #{@squares[x + 5]}   |   #{@squares[x + 6]}   |"\
           "   #{@squares[x + 7]}   |   #{@squares[x + 8]}   |"\
           "   #{@squares[x + 9]}   "
      puts "       |       |       |       |       |       |       |       |"
      unless y == 8
        puts "-------+-------+-------+-------+-------+"\
             "-------+-------+-------+-------"
      end
      x += 9
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def reset
    @numbers = (1..81).to_a
    @numbers.each { |x| @squares[x] = Square.new }
  end

  def winning_marker
    super(WINNING_LINES)
  end

  def threat(player_marker)
    super(WINNING_LINES, player_marker)
  end

  def opportunity(player_marker)
    super(WINNING_LINES, player_marker)
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

class TTTGame
  ROUNDS_PER_GAME = 5

  attr_accessor :board
  attr_reader :human, :computer

  def initialize
    @board = ThreeByThree.new
  end

  def play
    clear
    display_welcome_message
    initialize_human
    main_game
    display_goodbye_message
  end

  private

  def main_game
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
    initialize_board(board_size)
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

  def initialize_human
    @human = Human.new
    confirm_marker(@human)
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

    size
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

  def initialize_board(size)
    case size
    when 1
      @board = ThreeByThree.new
    when 2
      @board = FiveByFive.new
    when 3
      @board = NineByNine.new
    end
  end

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
    case whos_first
    when '1'
      @first_to_move = human.marker
    when '2'
      @first_to_move = computer.marker
    when '3'
      @first_to_move = [human.marker, computer.marker].sample
    end
    clear
  end

  def introduce_players
    clear
    puts "#{human.name}, you'll be playing this game against #{computer.name}"
    puts ""
  end

  def set_current_player
    @current_player = @first_to_move
  end

  def display_winner
    winner = human.score >= ROUNDS_PER_GAME ? 'You' : computer.name
    puts "#{winner} won the game!"
    puts ""
  end

  def game_over?
    computer.score == ROUNDS_PER_GAME || human.score == ROUNDS_PER_GAME
  end

  def reset_scores
    human.score = 0
    computer.score = 0
    clear
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

  def display_welcome_message
    puts "Welcome to Tic Tac Toe! The first player to win"\
         "#{ROUNDS_PER_GAME} rounds wins the game!"
    puts ""
  end

  def display_goodbye_message
    clear
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You're a #{human.marker}. #{computer.name}"\
         " is a #{computer.marker}.".center(board.width)
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
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

  def clear
    system "clear"
  end

  def reset
    board.reset
    set_current_player
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
