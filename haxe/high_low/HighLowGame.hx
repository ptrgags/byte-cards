package high_low;

import byte_cards.Card;
import byte_cards.Deck;
import byte_cards.CardComparator;

class HighLowGame {
    private var deck:Deck;
    private var player_card:ICard;
    private var comparator:ICardComparator;

    public function new() {
        deck = null;
        player_card = null;
        comparator = cast new AceHighCardComparator();
    }

    public function setup() {
        var cards:Array<ICard> = cast PlayingCard.all();
        deck = new Deck(cards);
        deck.shuffle();

        player_card = deck.draw_top();
    }

    public function play() {
        setup();
        var should_continue = true;
        while (!deck.empty && should_continue)
            should_continue = turn();
        game_over();
    }

    public function turn():Bool {
        var guess = "high";
        var card = deck.draw_top();
        var cmp = comparator.compare_cards(player_card, card);
        trace(player_card);
        trace(card);
        trace(cmp);

        return false;
    }

    public function game_over() {

    }
}
