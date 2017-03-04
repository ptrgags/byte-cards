interface IRank {
    public var value(default, null):Int;
    public var name(get, never):String;
    public var short_name(get, never):String;
}

class PlayingCardRank implements IRank {
    private var NAMES = [
        1 => "Ace",
        11 => "Jack",
        12 => "Queen",
        13 => "King"
    ];

    private var SHORT_NAMES = [
        1 => "A",
        10 => "T",
        11 => "J",
        12 => "Q",
        13 => "K"
    ];

    public function new(rank:Int) {
        value = rank;
    }

    public var value(default, null):Int;

    //Special rank names use the table, everything else just uses
    //the string representation of the number
    public var name(get, never):String;
    public function get_name() {
        if (NAMES.exists(value))
            return NAMES[value];
        else
            return '$value';
    }

    //Special rank names use the table, everything else just uses
    //the string representation of the number
    public var short_name(get, never):String;
    public function get_short_name():String {
        if (SHORT_NAMES.exists(value))
            return SHORT_NAMES[value];
        else
            return '$value';
    }

    public function toString() {
        return short_name;
    }

    static public function all():Array<PlayingCardRank> {
        return [for (i in 1...14) new PlayingCardRank(i)];
    }
}
