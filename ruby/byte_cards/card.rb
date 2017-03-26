require_relative "rank"
require_relative "suit"

class Card
    attr_reader :rank
    attr_reader :suit

    def initialize rank, suit
        @rank = rank
        @suit = suit
    end

    def long_name
        "#{@rank.long_name} of #{@suit.long_name}"
    end

    def short_name
        "#{@rank.short_name}#{@suit.short_name}"
    end

    def symbol
        "#{@rank.short_name}#{@suit.symbol}"
    end

    def min_rank
        @rank.class.min_rank
    end

    def max_rank
        @rank.class.max_rank
    end

    def to_s
        symbol
    end

    def inspect
        short_name
    end

    def self.all card_type
        ranks = Rank.all(card_type)
        suits = Suit.all(card_type)
        ranks.product(suits).map{|r, s| Card.new r, s}
    end
end
