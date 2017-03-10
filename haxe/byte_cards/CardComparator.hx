package byte_cards;

import byte_cards.Card;

interface ICardComparator {
    public function compare_cards(card_a:ICard, card_b:ICard):Int;
}

/**
 * Class for comparing any two cards
 */
class CardComparator {
    public function new() {}

    public function compare_cards(card_a:ICard, card_b:ICard):Int {
        //Make Aces 14 instead of 1
        var val_1 = card_a.rank.value;
        var val_2 = card_b.rank.value;

        //Compare the values
        if (val_1 < val_2)
            return -1;
        else if (val_1 > val_2)
            return 1;
        else
            return 0;
    }
}

/**
 * Compare PlayingCards where Aces are high
 *
 * IMPORTANT: The parameters must be PlayingCards 
 */
class AceHighCardComparator {
    public function new() {}

    public function compare_cards(card_a:ICard, card_b:ICard):Int {
        //Make Aces 14 instead of 1
        var val_1 = (card_a.rank.value == 1) ? 14 : card_a.rank.value;
        var val_2 = (card_b.rank.value == 1) ? 14 : card_b.rank.value;

        //Compare the values
        if (val_1 < val_2)
            return -1;
        else if (val_1 > val_2)
            return 1;
        else
            return 0;
    }
}
