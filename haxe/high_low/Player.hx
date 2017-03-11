package high_low;

import byte_cards.Card;

interface IPlayer {
    public var is_human(get, never):Bool;
    public function make_guess(card:ICard):String;
}

/**
 * AI that makes a constant guess regardless of inputs
 */
class AIConstantGuess implements IPlayer {
    private var guess:String;

    public var is_human(get, never):Bool;

    public function new(guess:String) {
        this.guess = guess;
    };

    public function make_guess(card:ICard):String {
        return guess;
    }

    public function get_is_human() {
        return false;
    }
}

/**
 * AI that chooses based on the rank of the card. If it's at or below the
 * midpoint, choose "higher". If it's above the midpoint, choose "lower".
 *
 * NOTE: This does not work when ace is high.
 */
class AIRankGuess implements IPlayer {
    public var is_human(get, never):Bool;

    public function new() {}

    public function make_guess(card:ICard):String {
        var min = card.min_rank.value;
        var max = card.max_rank.value;
        var midpoint = (min + max) / 2.0;
        if (card.rank.value > midpoint)
            return "lower";
        else
            return "higher";
    }

    public function get_is_human() {
        return false;
    }
}

//TODO: AI that chooses based on rank + counts cards

/**
 * Human player. Asks the user to make a guess given the card
 */
class HumanPlayer implements IPlayer {
    public var is_human(get, never):Bool;

    public function new() {}

    public function make_guess(card:ICard):String {
        var guess = "";
        Sys.println('You have card ${card}');
        while (guess != "higher" && guess != "lower" && guess != "the same") {
            Sys.println("Will the next card be ____{higher,lower,the same}?");
            Sys.print("> ");
            guess = Sys.stdin().readLine().toLowerCase();
        }
        return guess;
    }

    public function get_is_human() {
        return true;
    }
}
