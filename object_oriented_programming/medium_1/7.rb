class GuessingGame
  def initialize(low, high)
    @guess = nil
    @range = (low..high)
    @number = rand(range)
    @num_of_guesses = calculate_nog
  end
  
  def play
    loop do
      puts "You have #{num_of_guesses} #{guess_or_guesses} remaining."
      get_guess
      evaluate_guess
      update_num_of_guesses
      puts ''
      break if correct? || out_of_guesses?
    end
    
    game_over_message
  end
  
  private

  attr_reader :guess, :num_of_guesses, :number, :range
  
  def get_guess
    loop do
      print "Invalid guess. " if invalid_guess?
      print "Enter a number between #{range.first} and #{range.last}: "
      @guess = gets.chomp.to_i
      break unless invalid_guess?
    end
  end
  
  def evaluate_guess
    puts case guess
         when number
          "That's the number!"
         when (range.first...number) 
          "Your guess is too low."
         when (number + 1..range.last)
          "Your guess is too high."
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
  
  def calculate_nog
    Math.log2(range.size).to_i + 1
  end
  
  def guess_or_guesses
    num_of_guesses == 1 ? "guess" : "guesses"
  end
  
  def invalid_guess?
    !range.include?(guess) && guess != nil
  end
  
  def game_over_message
    puts correct? ? "You won!" : "You have no more guesses. You lost! The number was #{number}!"
  end
end

game = GuessingGame.new(501, 1500)
game.play