require_relative "card"

class Deck
    def initialize cards
        @cards = cards
    end

    def top
        @cards[-1]
    end

    def bottom
        @cards[0]
    end

    # Draw cards from the top
    # Topmost card becomes right most result
    # (as in pop)
    # if n is nil, return a single card, not an Array
    def draw_top *n
        @cards.pop *n
    end

    # Draw cards from the bottom
    # Bottommost card becomes left most result
    # (as in shift)
    # if n is nil, return a single card, not an Array
    def draw_bottom *n
        @cards.shift *n
    end

    # Add cards to top.
    # left most card is added first
    # (as in push)
    def add_top cards
        @cards.push *cards
    end

    # Add cards to the bottom
    # left most card becomes bottom
    # (as in unshift)
    def add_bottom cards
        @cards.unshift *cards
    end

    def count
        @cards.count
    end

    def empty?
        @cards.empty?
    end

    def shuffle
        @cards.shuffle!
    end

    def to_s
        "Deck: Top: #{top} Count: #{count}"
    end

    def inspect
        "Deck: Top < #{@cards.reverse.inspect} Count: #{count}"
    end
end

class DeckMaker
    def self.make_deck card_type, shuffle=true
        cards = Card.all card_type
        deck = Deck.new cards
        if shuffle
            deck.shuffle
        end
        deck
    end
end
