#!/usr/bin/env ruby
=begin
Solution to Project Euler #54: Poker Hands

Yes, I know this code is a mess. I plan to revisit this
to make a more robust PlayingCard class. I might revise the implementation
of ByteCard a bit too.
=end
require_relative "ByteCard.rb"

class PlayingCard < ByteCard
    RANK_NAMES = "a123456789TJQKA---"
    SHORT_RANK_NAMES = RANK_NAMES
    SUIT_SYMBOLS = ["♠", "\e[31m♥\e[0m", "♣", "\e[31m♦\e[0m"]

    # Maybe constants were a bad idea...
    def to_s
        "#{RANK_NAMES[rank]} of #{SUIT_NAMES[suit]}"
    end

    def inspect
        "#{SHORT_RANK_NAMES[rank]}#{SUIT_SYMBOLS[suit]}"
    end

    def self.from_str card
        rank_char, suit_char = card.chars

        rank = SHORT_RANK_NAMES.index rank_char
        suit = SHORT_SUIT_NAMES.index suit_char.downcase
        return self.new rank: rank, suit: suit
    end
end

ACE = 14

# Rank names from lowest to highest
HAND_RANKS = {
    high_card: 0,
    one_pair: 1,
    two_pair: 2,
    three_of_a_kind: 3,
    straight: 4,
    flush: 5,
    full_house: 6,
    four_of_a_kind: 7,
    straight_flush: 8,
    royal_flush: 9
}

def classify hand
    rank_counts = Hash.new(0)
    suit_counts = Hash.new(0)
    hand.each do |card|
        rank_counts[card.rank] += 1
        suit_counts[card.suit] += 1
    end

    max_ranks = rank_counts.values.max
    group_count = rank_counts.values.select {|x| x > 1}.count

    if max_ranks == 2 && group_count == 1
        return :one_pair
    elsif max_ranks == 2 && group_count == 2
        return :two_pair
    elsif max_ranks == 3 && group_count == 1
        return :three_of_a_kind
    elsif max_ranks == 3 && group_count == 2
        return :full_house
    elsif max_ranks == 4 && group_count == 1
        return :four_of_a_kind
    end

    ranks_high = rank_counts.keys.sort
    ranks_low = rank_counts.keys.map {|x| (x == ACE) ? 0 : x}.sort

    straight_high = ranks_high.each_cons(2).map {|a, b| b - a}.all? {|x| x == 1}
    straight_low = ranks_low.each_cons(2).map {|a, b| b - a}.all? {|x| x == 1}

    if straight_high && suit_counts.length == 1 && ranks_high[-1] == ACE
        return :royal_flush
    elsif (straight_high || straight_low) && suit_counts.length == 1
        return :straight_flush
    elsif (straight_high || straight_low)
        return :straight
    elsif suit_counts.length == 1
        return :flush
    else
        return :high_card
    end
end

$wins = 0

# Sort by length, then rank
def order_groups group1, group2
    cmp = group1.length <=> group2.length
    if cmp == 0
        return group1[0].rank <=> group2[0].rank
    else
        return cmp
    end
end

def compare_ranks hand1, hand2
    # Sort descending
    h1 = hand1.sort_by {|x| -x.rank}
    h2 = hand2.sort_by {|x| -x.rank}
    h1.zip(h2).each do |a, b|
        if a.rank == b.rank
            next
        else
            return a.rank <=> b.rank
        end
    end
    return 0
end

def compare_groups hand1, hand2
    groups1 = Hash.new {|h, k| h[k] = []}
    hand1.each {|x| groups1[x.rank] << x}
    groups2 = Hash.new {|h, k| h[k] = []}
    hand2.each {|x| groups2[x.rank] << x}

    grouped1 = groups1.values.sort(&method(:order_groups)).reverse
    grouped2 = groups2.values.sort(&method(:order_groups)).reverse

    grouped1.zip(grouped2).each do |a, b|
        if a[0].rank == b[0].rank
            next
        else
            return a[0].rank <=> b[0].rank
        end
    end
    return 0
end

def compare_hands hand1, hand2
    class1 = classify hand1
    class2 = classify hand2

    rank1 = HAND_RANKS[class1]
    rank2 = HAND_RANKS[class2]

    if rank1 > rank2
        puts "#{hand1}(#{class1}) beats #{hand2}(#{class2})"
        $wins += 1
    elsif rank1 < rank2
        puts "#{hand1}(#{class1}) loses against #{hand2}(#{class2})"
    else
        puts "#{hand1}(#{class1}) same type as #{hand2}(#{class2})"

        case class1
        when :royal_flush, :straight_flush, :straight, :high_card, :flush
            cmp = compare_ranks hand1, hand2
        when :four_of_a_kind, :full_house, :three_of_a_kind, :two_pair, :one_pair
            cmp = compare_groups hand1, hand2
        end

        if cmp == 1
            puts "hand1 wins!"
            $wins += 1
        elsif cmp == -1
            puts "hand2 wins"
        else
            puts "tie!"
        end
    end
end


File.open("poker.txt", "r").each_line do |line|
    cards = line.split(' ').map {|c| PlayingCard.from_str c}
    hand1, hand2 = cards.each_slice(5).to_a
    compare_hands hand1, hand2
end
puts "Player 1 wins #{$wins} times"
