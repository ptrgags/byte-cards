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

    public function new(player:IPlayer) {
        deck = null;
        player_card = null;
        comparator = cast new CardComparator();
        turn_num = 0;
        this.player = player;
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

    /**
     * Print a line to standard outpuut only if the
     * player is a human and thus is playing interactively
     */
    public function human_print(message:String) {
        if (player.is_human)
            Sys.println(message);
    }

    public function play():Int {
        setup();
        var should_continue = true;
        turn_num = 0;
        while (!deck.empty && should_continue) {
            turn_num++;
            human_print('== turn ${turn_num} ================');
            should_continue = turn();
            if (player.is_human)
                wait();
        }
        game_over();
        return turn_num;
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
        human_print('Player\'s card: the ${player_card.name}');

        //Get a guess from the player
        var guess = player.make_guess(player_card);

        human_print('Player guessed that the next card will be ${guess}');

        //Draw a new card
        var new_card = deck.draw_top();

        //Compare the cards.
        var actual = compare_cards(player_card, new_card);

        human_print('The next card is the ${new_card.name}, which is ${actual}');

        //Check if the guess is correct
        if (guess == actual) {
            human_print("Player's guess was correct!");
            player_card = new_card;
            return true;
        } else {
            human_print("Sorry, the player's guess was incorrect");
            return false;
        }
    }

    public function game_over() {
        human_print('== Game Over! ============');
        Sys.println('Player lasted ${turn_num} turn(s).');
    }
}
