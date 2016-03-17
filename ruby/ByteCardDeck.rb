require_relative "ByteCard"

class ByteCardDeck
    #Generate all the cards needed for this deck
    def initialize cards = []
        @deck = cards
    end

    def cards
        @deck
    end

    def num_cards
        @deck.length
    end

    #Shuffle cards in place
    def shuffle
        @deck.shuffle!
    end

    #Cut the deck into two sub-decks
    def cut
        half = num_cards / 2
        bottom = ByteCardDeck.new @deck[0...half]
        top = ByteCardDeck.new @deck[half..-1]
        [bottom, top]
    end

    #Draw cards from the top of the deck (push/pop end)
    #n - number of cards to draw.
    #returns a single ByteCard if n == 1, else returns
    #an array of ByteCards of length n
    def draw_top n = 1
        if n == 1
            @deck.pop
        else
            @deck.pop n
        end
    end

    #Just in case we need to draw from 
    #the bottom of the deck
    def draw_bottom n = 1
        if n == 1
            @deck.shift
        else
            @deck.shift n
        end
    end

    #'draw a card' usually  means "draw from the top"
    alias_method :draw, :draw_top

    def add_top cards
        @deck.push *cards
    end

    def add_bottom cards
        @deck.unshift *cards
    end

    #This could probably go either way, but more often
    #than not, decks are used like a queue. A discard
    #pile might want this the other way.
    alias_method :add, :add_bottom

    def to_s
        "Deck: #{@deck.length} cards remaining"
    end

    def inspect
        "ByteCardDeck<#{@deck.inspect}>"
    end

    def self.make_deck num_suits: ByteCard::SUITS, num_ranks: ByteCard::RANKS, num_wilds: 1, shuffle: true
        suits = *(0...num_suits)
        ranks = *(0...num_ranks)
        wilds = *(0...num_wilds)
        cards = suits.product(ranks, wilds).map do |suit, rank, wild|
            ByteCard.new suit: suit, rank: rank, wild: wild
        end

        if shuffle
            self.new cards.shuffle
        else
            self.new cards
        end
    end
end
