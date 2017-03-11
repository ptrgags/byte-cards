package high_low;

import byte_cards.Card;
import byte_cards.Deck;
import byte_cards.CardComparator;
import high_low.Player;

class HighLowGame {
    private var deck:Deck;
    private var player_card:ICard;
    private var comparator:ICardComparator;
    private var turn_num:Int;
    private var player:IPlayer;

    public function new() {
        deck = null;
        player_card = null;
        comparator = cast new AceHighCardComparator();
        turn_num = 0;
        //player = cast new HumanPlayer();
        player = cast new AIConstantGuess('higher');
    }

    public function setup() {
        var cards:Array<ICard> = cast PlayingCard.all();
        deck = new Deck(cards);
        deck.shuffle();

        player_card = deck.draw_top();
    }

    public function wait() {
        Sys.println("Press Enter to continue...");
        Sys.stdin().readLine();
    }

    public function play() {
        setup();
        var should_continue = true;
        turn_num = 0;
        while (!deck.empty && should_continue) {
            turn_num++;
            Sys.println('== turn ${turn_num} ================');
            should_continue = turn();
            if (player.is_human)
                wait();
        }
        game_over();
    }

    /**
     * Take a card compare value and see if the new card
     * is "higher" "lower" or the "same"
     */
    private function compare_cards(old_card:ICard, new_card:ICard):String {
        var cmp = comparator.compare_cards(old_card, new_card);
        if (cmp == -1)
            return "higher";
        else if (cmp == 1)
            return "lower";
        else
            return "the same";
    }

    /**
     * Simulate a turn:
     * 1. The player looks at his/her card and makes a guess whether the
     *    next card is "higher", "lower" or the "same"
     * 2. Draw a new card from the deck and compare to the player's card
     * 3. If the player guessed correctly, the player should take the card
     *    from the deck and continue to the next turn.
     * 
     * return true if the player guessed right, false if the player didn't
     * and therefore lost
     */
    public function turn():Bool {
        Sys.println('Player\'s card: the ${player_card.name}');

        //Get a guess from the player
        var guess = player.make_guess(player_card);

        Sys.println('Player guessed that the next card will be ${guess}');

        //Draw a new card
        var new_card = deck.draw_top();

        //Compare the cards.
        var actual = compare_cards(player_card, new_card);

        Sys.println('The next card is the ${new_card.name}, which is ${actual}');

        //Check if the guess is correct
        if (guess == actual) {
            Sys.println("Player's guess was correct!");
            player_card = new_card;
            return true;
        } else {
            Sys.println("Sorry, the player's guess was incorrect");
            return false;
        }
    }

    public function game_over() {
        Sys.println('== Game Over! ============');
        Sys.println('Player lasted ${turn_num} turn(s).');
    }
}
