#Functional version of byte_cards.rb
#designed with functional programming in mind
module ByteCardsFunctional
    RANKS=16
    SUITS=4
    WILDS=4
    RANK_NAMES = "0123456789ABCDEF"
    SHORT_RANK_NAMES = RANK_NAMES
    SUIT_NAMES = ["Spades", "Hearts", "Clubs", "Diamonds"]
    SHORT_SUIT_NAMES = "shcd"

    def make_card suit, rank, wild = 0
        wild &= WILDS - 1
        suit &= SUITS - 1
        rank &= RANKS - 1
        wild << 6 | suit << 4 | rank
    end

    def rank card
        card & (RANKS - 1)
    end

    def suit card
        card >> 4 & (SUITS - 1)
    end

    def wild card
        card >> 6 & (WILDS - 1)
    end

    def rank_cmp card1, card2
        rank(card1) <=> rank(card2)
    end

    def name card, rank_names: RANK_NAMES, suit_names: SUIT_NAMES, wild_names: []
        "#{rank_names[rank card]} of #{suit_names[suit card]}"
    end

    def short_name card, rank_names: SHORT_RANK_NAMES, suit_names: SHORT_SUIT_NAMES, wild_names: []
        if wild_names
            "#{rank_names[rank card]}#{suit_names[suit card]}(#{wild_names[wild card]})"
        else
            "#{rank_names[rank card]}#{suit_names[suit card]}"
        end
    end

    def make_deck num_suits: SUITS, num_ranks: RANKS, num_wilds: 1, shuffle: true
        suits = *(0...num_suits)
        ranks = *(0...num_ranks)
        wilds = *(0...num_wilds)
        combos = suits.product(ranks, wilds).map{|suit, rank, wild| make_card suit, rank, wild}
        if shuffle
            combos.shuffle
        else
            combos
        end
    end

    def cut deck
        half = deck.length / 2
        bottom = deck[0...half]
        top = deck[half..-1]
        [bottom, top]
    end

    def draw deck, n=1
        if n == 1
            deck.pop
        else
            deck.pop n
        end
    end
end
