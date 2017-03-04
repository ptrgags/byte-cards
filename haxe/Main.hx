import Suit;
import Rank;

class Main {
    static public function main():Void {
        for (suit in PlayingCardSuit.all()) {
            for (rank in PlayingCardRank.all()) {
                trace('${rank}${suit} ${suit.symbol}');
            }
        }
    }
}
