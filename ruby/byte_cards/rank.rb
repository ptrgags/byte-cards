class Rank
    attr_reader :value

    def initialize value
        @value = value
    end

    def long_name
        short_name
    end

    def short_name
        @value.to_s
    end

    def to_s
        long_name
    end

    def inspect
        short_name
    end

    def self.get_class card_type
        case card_type
        when 'playing_card'
            PlayingCardRank
        when 'byte_card'
            ByteCardRank
        when 'fruit'
            FruitRank
        else
            raise ArgumentError
        end
    end

    def self.get_rank card_type, val
        get_class(card_type).new val
    end

    def self.all card_type
        get_class(card_type).all
    end
end

class PlayingCardRank < Rank
    @@MIN_RANK = 1
    @@MAX_RANK = 13

    @@NAMES = { 
        1 => "Ace",
        11 => "Jack",
        12 => "Queen",
        13 => "King"
    }

    @@SHORT_NAMES = {
        1 => "A",
        10 => "T",
        11 => "J",
        12 => "Q",
        13 => "K"
    }

    def long_name
        @@NAMES[@value] || @value.to_s
    end

    def short_name
        @@SHORT_NAMES[@value] || @value.to_s
    end

    def self.min_rank
        PlayingCardRank.new @@MIN_RANK
    end

    def self.max_rank
        PlayingCardRank.new @@MAX_RANK
    end

    def self.all
        (@@MIN_RANK..@@MAX_RANK).map {|x| self.new x}
    end
end

class ByteCardRank < Rank
    @@MIN_RANK = 0
    @@MAX_RANK = 15

    def long_name
        short_name
    end

    def short_name
        @value.to_s(16).upcase
    end

    def self.min_rank
        ByteCardRank.new @@MIN_RANK
    end

    def self.max_rank
        ByteCardRank.new @@MAX_RANK
    end

    def self.all
        (@@MIN_RANK..@@MAX_RANK).map {|x| self.new x}
    end
end

class FruitRank < Rank
    @@MIN_RANK = 1
    @@MAX_RANK = 8

    def self.min_rank
        FruitRank.new @@MIN_RANK
    end

    def self.max_rank
        FruitRank.new @@MAX_RANK
    end

    def self.all
        (@@MIN_RANK..@@MAX_RANK).map {|x| self.new x}
    end
end
