import Card;

class Main {
    static public function main():Void {
        for (card in PlayingCard.all()) {
            //This only works in terminals with good UTF-8 support.
            //(a.k.a. not Windows);
            trace(card.symbol);
        }
    }
}
