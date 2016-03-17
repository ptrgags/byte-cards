#ByteCard, a card that fits in a byte
#Each card is represented by a single byte
#in the format WW SS RRRR
#where:
#   WW - wild bits (User-defined)
#   SS - suit index 0-3
#   RRRR - rank index 0-15
class ByteCard
    RANKS=16
    SUITS=4
    WILDS=4
    RANK_NAMES = "0123456789ABCDEF"
    SHORT_RANK_NAMES = RANK_NAMES
    SUIT_NAMES = ["Spades", "Hearts", "Clubs", "Diamonds"]
    SHORT_SUIT_NAMES = "shcd"

    def initialize value: nil, rank: 0, suit: 0, wild: 0
        if value.nil?
            @value = wild << 6 | suit << 4 | rank
        else
            @value = value
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

    #First of the two wild bits
    #i.e. X0000000
    def wild_bit1
        @value >> 7 & 0x01
    end
    
    #First of the two wild bits
    #i.e. 0X000000
    def wild_bit2
        @value >> 6 & 0x01
    end

    def to_s
        "#{RANK_NAMES[rank]} of #{SUIT_NAMES[suit]}"
    end

    def inspect
        "#{SHORT_RANK_NAMES[rank]}#{SHORT_SUIT_NAMES[suit]}"
    end
end
