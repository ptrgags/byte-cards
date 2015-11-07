#!/usr/bin/env ruby
#Test of ByteCard and Deck in OO style
#Goal: Play a game of War vs the computer

require_relative 'ByteCard'
require_relative 'ByteCardDeck'

#Gather all cards and split into two decks
all_cards = ByteCardDeck.make_deck
player_deck, cpu_deck = all_cards.cut

#Emulate a round of War:
#TODO: Actually make a full game of War
puts "Game of War, Round 1"
cpu_card = cpu_deck.draw
puts "CPU draws: #{cpu_card}"
player_card = player_deck.draw
puts "Player draws: #{player_card}"

if cpu_card.rank == player_card.rank
    puts "WAR!"
elsif cpu_card.rank > player_card.rank
    puts "CPU wins!"
else
    puts "Player wins!"
end
