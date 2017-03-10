package high_low;

import byte_cards.Card;
import byte_cards.Deck;

class HighLowTable {
    private var player_card:ICard;
    private var other_card:ICard;
    private var deck:Deck;

    public function new() {
        deck = null;
        player_card = null;
        other_card = null;
    }

    public function setup() {
        //Create the deck and shuffle it
        var cards:Array<ICard> = cast PlayingCard.all();
        deck = new Deck(cards);
        deck.shuffle();

        //Draw a card for the player
        player_card = deck.draw_top();
    }

    public function deal_next_card() {
        other_card = deck.draw_top();
    }

    public function collect_card() {
        player_card = other_card;
        other_card = null;
    }

    public function compare_cards():Int {
        var cmp = new AceHighCardComparator();
        var result = cmp.compare(player_card, other_card);

        if (result == -1)
            return HIGHER;
        else if (result == 1)
            return LOWER;
        else
            return SAME;
    }

    public function toString() {
        return '${player_card} ${other_card} ${deck.count}';
    }
}
