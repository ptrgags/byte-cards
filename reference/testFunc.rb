#!/usr/bin/env ruby
#Test of ByteCard and Deck in functional style
#Goal: Play a game of War vs the computer

require_relative "byte_cards"
include ByteCardsFunctional

#Gather all cards and split into two decs
all_cards = make_deck
player_deck, cpu_deck = cut all_cards

#Emulate a round of War:
#TODO: Actually make a full game of War
puts "Game of War, Round 1"
cpu_card = draw cpu_deck
puts "CPU draws: #{name cpu_card}"
player_card = draw player_deck
puts "Player draws: #{name player_card}"

if rank(cpu_card) == rank(player_card)
    puts "WAR!"
elsif rank(cpu_card) > rank(player_card)
    puts "CPU Wins!"
else
    puts "Player wins!"
end
