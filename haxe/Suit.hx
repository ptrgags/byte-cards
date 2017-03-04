interface ISuit {
    // Get the underlying value of this suit
    public var value(default, null):Int;
    // Get the full name of this suit like "Hearts"
    public var name(get, never):String;
    // Get the short name of this suit like 'h'
    public var short_name(get, never):String;
    // Get a Unicode symbol for this suit like ♠.
    // TODO: I need to learn how to encode Unicode properly in Haxe
    public var symbol(get, never):String;
}

class PlayingCardSuit implements ISuit {
    private static var NAMES = [
        0 => "Spades",
        1 => "Hearts",
        2 => "Clubs",
        3 => "Diamonds"
    ];
    private static var SHORT_NAMES = [
        0 => 's',
        1 => 'h',
        2 => 'c',
        3 => 'd'
    ];
    private static var SYMBOLS = [
        0 => "♠",
        1 => "♥",
        2 => "♣",
        3 => "♦"
    ];

    public function new(val:Int) {
        value = val;
    }

    public var value(default, null):Int;

    public var name(get, never):String;
    public function get_name():String {
        return NAMES[value];
    }

    public var short_name(get, never):String;
    public function get_short_name():String {
        return SHORT_NAMES[value];
    }

    public var symbol(get, never):String;
    public function get_symbol():String {
        trace(SYMBOLS);
        return SYMBOLS[value];
    }

    public function toString() {
        return short_name;
    }

    static public function all():Array<PlayingCardSuit> {
        return [for (i in 0...4) new PlayingCardSuit(i)];
    }
}
