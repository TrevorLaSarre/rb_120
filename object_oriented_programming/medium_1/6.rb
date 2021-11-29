class GuessingGame
  def initialize
    @number = nil
    @guess = nil
    @num_of_guesses = 7
  end
  
  def play
    new_number
    
    loop do
      puts "You have #{num_of_guesses} guesses remaining."
      get_guess
      evaluate_guess
      update_num_of_guesses
      puts ''
      break if correct? || out_of_guesses?
    end
    
    puts game_over_message
  end
  
  private

  attr_reader :guess, :num_of_guesses, :number

  def new_number
    @number = rand(0..100)
  end
  
  def get_guess
    loop do
      print "Invalid guess. " if invalid_guess?
      print "Enter a number between 1 and 100: "
      @guess = gets.chomp.to_i
      break unless invalid_guess?
    end
  end
  
  def evaluate_guess
    puts case guess
         when number       then "That's the number!"
         when (0...number) then "Your guess is too low."
         else                   "Your guess is too high."
    end
  end
  
  def update_num_of_guesses
    @num_of_guesses -= 1
  end
  
  def out_of_guesses?
    num_of_guesses == 0
  end
  
  def correct?
    guess == number
  end
  
  def invalid_guess?
    !(0..100).to_a.include?(guess) && guess != nil
  end
  
  def game_over_message
    correct? ? "You won!" : "You have no more guesses. You lost!"
  end
end

game = GuessingGame.new
game.play