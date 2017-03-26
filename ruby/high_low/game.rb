require_relative "../byte_cards/deck"
require_relative "../byte_cards/card_comparator"

class HighLowGame
    def initialize player, card_type, console
        @player = player
        @card_type = card_type
        @console = console
        @deck = nil
        @player_card = nil
        @correct_count = 0
        @should_continue = true
        @comparator = CardComparator.new
    end

    def setup
        @correct_count = 0
        @deck = DeckMaker.make_deck @card_type
        @player_card = @deck.draw_top
        @should_continue = true
    end

    def continue?
        @should_continue and not @deck.empty?
    end

    def compare_cards old_card, new_card
        case @comparator.compare old_card, new_card
        when -1 
            'higher'
        when 1 
            'lower'
        else
            'the same'
        end
    end

    def turn
        guess = @player.make_guess @player_card
        new_card = @deck.draw_top
        actual = compare_cards @player_card, new_card

        if guess == actual
            @console.println "Correct!"
            @correct_count += 1
            @player_card = new_card
        else 
            @console.println "Incorrect! The next card was #{actual}"
            @should_continue = false
        end
    end

    def game_over
        @console.println "Game Over!"
        @console.println "Player got #{@correct_count} guesses correct!", false
    end

    def play
        setup
        while continue?
            turn
        end
        game_over
    end
end
