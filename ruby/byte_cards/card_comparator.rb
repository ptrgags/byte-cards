class CardComparator
    def compare card_a, card_b
        return card_a.rank.value <=> card_b.rank.value
    end
end
