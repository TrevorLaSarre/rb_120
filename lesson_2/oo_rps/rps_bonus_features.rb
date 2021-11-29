module Formatable
  def new_line
    puts "\n"
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def prompt(message)
    puts "=> #{message}"
  end
end

class Move
  attr_accessor :value

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value = nil)
    @value = value
  end

  def assign(value)
    case value
    when VALUES[0] then Rock.new(value)
    when VALUES[1] then Paper.new(value)
    when VALUES[2] then Scissors.new(value)
    when VALUES[3] then Lizard.new(value)
    when VALUES[4] then Spock.new(value)
    end
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end
end

class Rock < Move
  def >(other_move)
    other_move.lizard? || other_move.scissors?
  end

  def <(other_move)
    other_move.paper? || other_move.spock?
  end
end

class Paper < Move
  def >(other_move)
    other_move.spock? || other_move.rock?
  end

  def <(other_move)
    other_move.scissors? || other_move.lizard?
  end
end

class Scissors < Move
  def >(other_move)
    other_move.lizard? || other_move.paper?
  end

  def <(other_move)
    other_move.rock? || other_move.spock?
  end
end

class Lizard < Move
  def >(other_move)
    other_move.paper? || other_move.spock?
  end

  def <(other_move)
    other_move.scissors? || other_move.rock?
  end
end

class Spock < Move
  def >(other_move)
    other_move.scissors? || other_move.rock?
  end

  def <(other_move)
    other_move.lizard? || other_move.paper?
  end
end

class Player
  include Formatable

  attr_accessor :move, :name, :score, :moves

  def initialize(n = nil)
    assign_name(n)
    @score = 0
    @moves = []
  end

  def update_score
    self.score += 1
  end

  def winner?
    self.score == RPSGame::WINNING_SCORE
  end

  def store_moves(current_move)
    moves << current_move.value
  end
end

class Human < Player
  def assign_name(n)
    loop do
      new_line
      prompt "What's your name?"
      n = gets.chomp
      break unless n.empty?
      prompt "Sorry, must enter a value"
    end

    self.name = n
  end

  def introduction
    clear_screen
    prompt "Hi #{@name}!"
  end

  def choose
    choice = nil

    loop do
      prompt "Please choose rock, paper, scissors, lizard, or spock"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      prompt "That's an invalid choice!"
    end

    self.move = Move.new.assign(choice)
  end

  def reset
    self.moves = []
    self.score = 0
  end
end

class Computer < Player
  NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def assign_name(n)
    self.name = n
  end

  def assign(name)
    case name
    when NAMES[0] then R2D2.new(name)
    when NAMES[1] then Hal.new(name)
    when NAMES[2] then Chappie.new(name)
    when NAMES[3] then Sonny.new(name)
    when NAMES[4] then Number5.new(name)
    end
  end

  def introduction
    prompt "You'll be playing this game against #{@name}."
    new_line
  end
end

class R2D2 < Computer
  # Only chooses rock (And is bad at the game)
  def choose(_)
    self.move = Move.new.assign(Move::VALUES[0])
  end
end

class Hal < Computer
  # Has a 20x probability of choosing scissors over rock, spock, or lizard
  # and never chooses paper
  def choose(_)
    choices = ['rock', 'spock', 'lizard']
    20.times { choices << 'scissors' }
    self.move = Move.new.assign(choices.sample)
  end
end

class Chappie < Computer
  # Has a randomly generated probability (from 0-100x) of choosing
  # any given move
  def choose(_)
    choices = []

    (Move::VALUES).each do |x|
      rand(0..100).times { choices << x }
    end

    self.move = Move.new.assign(choices.sample)
  end
end

class Sonny < Computer
  # Will always choose the same thing you just chose, leading to a perpetual tie
  # and a deeply boring and frustrating game
  def choose(choices)
    self.move = Move.new.assign(choices[-1])
  end
end

class Number5 < Computer
  # Learns from you and will only make a selection from the moves
  # you've previously made
  def choose(choices)
    self.move = Move.new.assign(choices.sample)
  end
end

# Game Orchestration Engine
class RPSGame
  WINNING_SCORE = 10

  include Formatable
  attr_accessor :human, :computer

  def display_welcome_message
    prompt "Welcome to Rock, Paper, Scissors, Lizard, Spock! " \
           "The first one with #{WINNING_SCORE} points wins the game!"
  end

  def display_goodbye_message
    clear_screen
    prompt "Thanks for playing Rock, Paper, Scissors, Lizard, Spock! Goodbye!"
  end

  def display_winner
    clear_screen
    prompt "You chose #{human.move.value}"
    prompt "#{computer.name} chose #{computer.move.value}"
    prompt winner
  end

  def winner
    if human.move > computer.move
      human.update_score
      "#{human.name} wins!"
    elsif computer.move > human.move
      computer.update_score
      "#{computer.name} wins!"
    else
      "It's a tie!"
    end
  end

  def display_score
    new_line
    prompt "#{human.name} has #{human.score} points"
    prompt "#{computer.name} has #{computer.score} points"
  end

  def round_message
    new_line
    prompt "Ready for the next round? (y/n)"
  end

  def game_message
    new_line
    prompt "Would you like to start a new game? (y/n)"
  end

  def play_again?(type)
    answer = nil

    loop do
      round_message if type == :round
      game_message if type == :game
      answer = gets.chomp
      clear_screen
      break if ['y', 'n'].include?(answer.downcase[0])
      prompt "That's not a valid answer"
    end

    answer.downcase[0] == 'y'
  end

  def game_over?
    human.winner? || computer.winner?
  end

  def game_winner
    human.winner? ? human.name : computer.name
  end

  def move_history?
    clear_screen
    answer = nil

    loop do
      prompt "Would you like to see the move history for this game (y/n)?"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase[0])
      prompt "That's not a valid answer"
    end

    answer.downcase[0] == 'y'
  end

  def move_history
    clear_screen
    prompt "You chose:"
    moves_list(human)
    new_line
    prompt "#{computer.name} chose:"
    moves_list(computer)
  end

  def moves_list(player)
    player.moves.each_with_index do |move, idx|
      puts "   - Round #{idx + 1}: #{move}"
    end
  end

  def initialize_play
    display_welcome_message
    self.human = Human.new
    human.introduction
  end

  def new_game
    self.computer = Computer.new.assign(Computer::NAMES.sample)
    computer.introduction
    human.reset
  end

  def new_round
    loop do
      human.store_moves(human.choose)
      computer.store_moves(computer.choose(human.moves))
      display_winner
      display_score
      break if game_over? || !play_again?(:round)
    end
  end

  def end_of_game
    prompt "#{game_winner} wins the game!" if game_over?
    move_history if move_history?
  end

  def play
    initialize_play

    loop do
      new_game
      new_round
      end_of_game
      break unless play_again?(:game)
    end

    display_goodbye_message
  end
end

RPSGame.new.play
