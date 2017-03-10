package byte_cards;

import byte_cards.Rank;
import byte_cards.Suit;

interface ICard {
    public var rank(default, null):IRank;
    public var suit(default, null):ISuit;
    //Name of card like "A of Spades";
    public var name(get, never):String;
    //Card short name like As
    public var short_name(get, never):String;
    //Card with Unicode symbol like A♠
    //NOTE: This doesn't display well in Windows-based terminals due to lack
    //of proper UTF-8 support
    public var symbol(get, never):String;
}

class PlayingCard implements ICard {
    public var rank(default, null):IRank;
    public var suit(default, null):ISuit;
    public var name(get, never):String;
    public var short_name(get, never):String;
    public var symbol(get, never):String;

    public function new(rank:IRank, suit:ISuit) {
        this.rank = rank;
        this.suit = suit;
    }

    public function get_name():String {
        return '${this.rank.name} of ${this.suit.name}';
    }

    public function get_short_name():String {
        return '${this.rank}${this.suit}';
    }

    public function get_symbol():String {
        return '${this.rank}${this.suit.symbol}';
    }

    public function toString() {
        return short_name;
    }

    static public function all():Array<PlayingCard> {
        var arr = new Array<PlayingCard>();
        for (suit in PlayingCardSuit.all()) {
            for (rank in PlayingCardRank.all()) {
                var card = new PlayingCard(rank, suit);
                arr.push(card);
            }
        }
        return arr;
    }
}
