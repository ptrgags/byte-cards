#!/usr/bin/env ruby
#Test of ByteCard and Deck in OO style.
#Goal: Play a game of WAR vs the computer

require_relative 'ByteCard'
require_relative 'ByteCardDeck'

#First, let's define our playing card names
class NerdCard < ByteCard
    SUIT_NAMES = ["Spades", "Hearts", "Clubs", "Diamonds"]
    RANK_NAMES = "0123456789ABCDEF"
    SUIT_SHORT_NAMES = "shcd"

    def to_s
        "#{RANK_NAMES[rank]} of #{SUIT_NAMES[suit]}"
    end

    def inspect
        "#{RANK_NAMES[rank]}#{SUIT_SHORT_NAMES[suit]}"
    end
end

#Generate the cards
#TODO: put this somewhere
suits = *(0...ByteCard::SUITS)
ranks = *(0...ByteCard::RANKS)
cards = suits.product(ranks).map {|suit, rank| NerdCard.new suit: suit, rank: rank}

#Collect into a deck
all_cards = ByteCardDeck.new cards

#Shuffle and divide into two decks, one for the player, one for CPU
all_cards.shuffle
player_deck, cpu_deck = all_cards.cut

#Emulate a round of War:
#TODO: Actually make a full game of War
puts "Game of War, Round 1"
cpu_card = cpu_deck.draw
puts "CPU draws: #{cpu_card}"
player_card = player_deck.draw
puts "Player draws: #{player_card}"
if cpu_card == player_card
    puts "WAR!"
elsif cpu_card > player_card
    puts "CPU wins!"
else
    puts "Player wins!"
end
