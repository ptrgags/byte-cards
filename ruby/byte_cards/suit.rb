class Suit
    def initialize value
        @value = value
    end

    def long_name
        raise "NotImplemented"
    end

    def short_name
        raise "NotImplemented"
    end

    def to_s
        symbol
    end

    def inspect
        short_name
    end

    def self.get_class card_type
        case card_type
        when 'playing_card'
            PlayingCardSuit
        when 'byte_card'
            ByteCardSuit
        when 'fruit'
            FruitSuit
        else
            raise ArgumentError
        end
    end

    def self.get_suit card_type, val
        get_class(card_type).new val
    end

    def self.all card_type
        get_class(card_type).all
    end
end

class PlayingCardSuit < Suit
    @@NAMES = [
        "Spades",
        "Hearts",
        "Clubs",
        "Diamonds"
    ] 

    @@SYMBOLS = "♠♥♣♦"

    def long_name
        @@NAMES[@value]
    end

    def short_name
        @@NAMES[@value][0].downcase
    end

    def symbol
        @@SYMBOLS[@value]
    end

    def self.all
        (0...4).map {|x| self.new x}
    end
end

class ByteCardSuit < Suit
    @@SYMBOLS = "αβδγ"

    def long_name
        symbol
    end

    def short_name
        symbol
    end

    def symbol 
        @@SYMBOLS[@value]
    end

    def self.all
        (0...4).map {|x| self.new x}
    end
end

class FruitSuit < Suit
    @@NAMES = [
        "Apples",
        "Pears",
        "Bananas",
        "Watermelons",
        "Grapes",
        "Strawberries",
        "Cherries",
        "Pineapples",
    ]

    @@SYMBOLS = "🍎🍐🍌🍉🍇🍓🍒🍍"
    
    def long_name
        @@NAMES[@value]
    end

    def short_name
        @@NAMES[@value][0...2]
    end

    def symbol
        @@SYMBOLS[@value]
    end

    def self.all
        (0...8).map {|x| self.new x}
    end
end
