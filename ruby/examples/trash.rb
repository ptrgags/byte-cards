#!/usr/bin/env ruby
require_relative "../ByteCard"
require_relative "../ByteCardDeck"


class Player
    attr_accessor :name

    def initialize name
        @name = name
        @cards_left = 10
        @cards = []
        @cards_face_up = []
    end

    def draw deck
        @cards = deck.draw @cards_left
        @cards_face_up = @cards_left.times.map {false}
    end

    def process_card card
        index = card.rank
        if index >= @cards_left
            card
        elsif @cards_face_up[index]
            card
        else
            swap card, index
        end
    end

    def swap card, index
        temp = card
        card = @cards[index]
        @cards[index] = temp
        card
    end

    def cards_str
        zipped = @cards.zip @cards_face_up
        strs = zipped.map {|card, face_up| face_up ? card.inspect : 'X'}
        strs.join ', '
    end
    
    def to_s
        "#{@name}: #{cards_str}"
    end
end

def turn player, deck
    name = player.name
    puts "#{name}'s turn"
    loop do
        current = deck.draw
        puts "#{name} draws: #{current}"
        break
    end
end

deck = ByteCardDeck.make_deck
deck.shuffle

discard = ByteCardDeck.new []

player1 = Player.new "Alice"
player2 = Player.new "Bob"

player1.draw deck
player2.draw deck

puts player1
puts player2

turn player1, deck

=begin
if current.rank >= cards1.length
    puts "Nope"
elsif face_up1[current.rank]
    puts "Already have a card there sir"
else
    temp = cards1[current.rank]
    cards1[current.rank] = current
    face_up1[current.rank] = true
    current = temp
    puts "Success!"
    puts "The hidden card was #{current}"
end

puts "Current state:"
puts card_str cards1, face_up1
puts card_str cards2, face_up2
=end
