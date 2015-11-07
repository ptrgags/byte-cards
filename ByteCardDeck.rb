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

    #Draw n card
    def draw n=1
        if n == 1
            @deck.pop
        else
            @deck.pop n
        end
    end

    def add_top cards
        @deck.push *cards
    end

    def add_bottom cards
        @deck.unshift *cards
    end

    def to_s
        "Deck: #{@deck.length} cards remaining"
    end

    def inspect
        "ByteCardDeck<#{@deck.inspect}>"
    end
end
