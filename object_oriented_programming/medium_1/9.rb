class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  
  def initialize
    @cards = []
    reset
  end
  
  def draw
    reset if @cards.empty?
    @cards.pop
  end
  
  private
  
  def reset
    13.times do |x|
      4.times do |y|
        @cards << Card.new(RANKS[x], SUITS[y])
      end
    end

    @cards.shuffle!
  end
end

class Card
  include Comparable
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
  
  def <=>(other_card)
    numeric_rank <=> other_card.numeric_rank
  end
  
  def numeric_rank
    case rank
    when (1..10) then rank
    when "Jack"  then 11
    when "Queen" then 12
    when "king"  then 13
    when "Ace"   then 14
    else              nil
    end
  end
  
  def to_s
    "#{rank} of #{suit}"
  end
end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.