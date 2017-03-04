import Card;
import Deck;

class Main {
    static public function main():Void {
        var cards:Array<ICard> = cast PlayingCard.all();
        var deck = new Deck(cards);
        for (i in 0...52)
            trace(deck.draw_top());
        trace(deck.count); //Should be 0

    }
}
