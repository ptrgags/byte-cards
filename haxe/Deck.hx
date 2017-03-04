import Card;
import Random;

interface IDeck {
    //TODO: Add a lot more methods as needed. But design from higher up
    public var top(get, never):ICard;
    public var bottom(get, never):ICard;
    public var count(get, never):Int;
    public function draw_top(n:Int=1):ICard;
    public function shuffle():Void;
}

class Deck implements IDeck {
    //Deque that represents the cards. top is to the right
    //where bottom is on the left
    private var cards:Array<ICard>;

    public var top(get, never):ICard;
    public var bottom(get, never):ICard;
    public var count(get, never):Int;

    public function new(cards:Array<ICard>) {
        this.cards = cards;
    }

    public function get_top():ICard {
        return cards[cards.length - 1];
    }

    public function get_bottom():ICard {
        return cards[0];
    }

    public function get_count():Int {
        return cards.length;
    }

    public function draw_top(n:Int=1):ICard {
        return cards.pop();
    }

    public function shuffle():Void {
        Random.shuffle(cards);
    }

}
