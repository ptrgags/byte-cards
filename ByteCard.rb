class ByteCard
    include Comparable
    RANKS=16
    SUITS=4
    WILDS=4

    def initialize value: -1, rank: 0, suit: 0, wild: 0
        if value >= 0
            @value = value
        else
            @value = wild << 6 | suit << 4 | rank
        end
    end

    #Rank is the rightmosts  4 bits
    #i.e. 0000XXXX
    def rank
        @value & (RANKS - 1)
    end

    #Suit is the 2 bits in between
    #the wildcard number and the rank
    #i.e. 00XX0000
    def suit
        @value >> 4 & (SUITS - 1)
    end

    #Wild card number is the first two
    #bits, i.e. XX000000
    def wild
        @value >> 6 & (WILDS - 1)
    end

    #By default, when we compare cards, we compare
    #only the ranks
    def <=> other
        rank <=> other.rank
    end

    #Default representation. Override in subclass for game specific
    #information.
    def to_s
        "#{rank} of #{suit} (Wild: #{wild})"
    end

    def inspect
        "ByteCard<#{@value}: Rank: #{rank} Suit: #{suit} Wild: #{wild}>"
    end
end
