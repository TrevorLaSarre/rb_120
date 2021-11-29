class Participant
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def hit(deck)
    @hand << deck.deal
  end

  def values
    @values = @hand.map(&:value)
  end

  def hand_values
    hand_values = ''

    values.each_with_index do |value, idx|
      return "#{@values[0]} and #{@values[1]}" if @values.size == 2
      hand_values << (idx == (@values.size - 1) ? "and #{value}" : "#{value}, ")
    end

    hand_values
  end

  def busted?
    total > 21
  end

  def total
    seperate_aces
    @total = non_aces_total
    add_aces unless @aces.empty?
    @total
  end

  private

  def seperate_aces
    @non_aces, @aces = @hand.partition { |x| x.value != 'Ace' }
  end

  def non_aces_total
    @non_aces.map(&:points).sum
  end

  def add_aces
    @aces.size.times { @total += non_aces_total <= 10 ? 11 : 1 }
  end
end

class Deck
  attr_reader :cards

  def initialize
    @cards = []

    4.times do |x|
      13.times do |y|
        @cards << Card.new(Card::SUITS[x], Card::VALUES[y])
      end
    end

    shuffle!
  end
  
  def shuffle!
    cards.shuffle!
  end

  def deal
    @cards.delete(@cards.sample)
  end
end

class Card
  attr_reader :suit, :value, :points

  SUITS = ['Hearts', 'Spades', 'Clubs', 'Diamonds']
  VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']

  def initialize(suit, value)
    @suit = suit
    @value = value
    assign_points
  end

  def to_s
    "#{value} of #{suit}"
  end

  private

  def assign_points
    @points = if value.class == Integer
                value
              elsif value == "Ace"
                [1, 11]
              else
                10
              end
  end
end

class Game
  attr_accessor :deck, :dealer, :player

  def initialize
    @deck = Deck.new
    @dealer = Participant.new
    @player = Participant.new
  end

  def start
    loop do
      deal_cards
      show_initial_cards
      main_gameplay
      break unless play_again?
      initialize
    end
  end

  def deal_cards
    [dealer, player].each do |participant|
      2.times { participant.hit(deck) }
    end
  end

  def show_initial_cards
    puts "Dealer has: #{dealer.values[0]} and an Unknown Card"
    puts "You have: #{player.hand_values}"
  end

  def main_gameplay
    player_turn
    dealer_turn
    show_result
  end

  def play_again?
    answer = nil

    loop do
      puts ''
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "I'm sorry -- you must enter y or n"
    end

    system 'clear'
    answer == 'y'
  end

  def player_turn
    loop do
      hit_or_stay
      answer = gets.chomp
      puts ""
      break if interpret_answer(answer) || player.busted?
    end
  end

  def interpret_answer(answer)
    if answer == '1'
      player_hits
    elsif answer == '2'
      system 'clear'
    else
      puts "I'm sorry -- you must enter 1 or 2"
      nil
    end
  end

  def hit_or_stay
    puts ""
    puts "Would you like to hit or stay?"
    puts ">> Press 1 to hit"
    puts ">> Press 2 to stay"
  end

  def player_hits
    player.hit(deck)
    system 'clear'
    puts "You got a #{player.values[-1]} and your current hand is: "\
         "#{player.hand_values}"
    busted_message(player) if player.busted?
  end

  def dealer_turn
    while dealer.total < 17 && !player.busted?
      dealer.hit(deck)
      puts "The dealer hit and got a #{dealer.values[-1]}"
      busted_message(dealer) if dealer.busted?
    end
  end

  def busted_message(participant)
    puts ''
    puts participant == player ? "You busted!" : "The dealer busted!"
  end

  def show_result
    return if someone_busted?
    puts "You have a total of #{player.total}"
    puts "The dealer has a total of #{dealer.total}"
    puts ''
    puts winner
  end

  def someone_busted?
    player.busted? || dealer.busted?
  end

  def winner
    return "It's a tie!" if player.total == dealer.total
    player.total > dealer.total ? "You won!" : "The dealer won!"
  end
end

Game.new.start
