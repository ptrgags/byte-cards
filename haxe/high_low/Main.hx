package high_low;

import high_low.HighLowGame;

class Main {
    static public function main():Void {
        var game = new HighLowGame();

        var total_turns = 0.0;
        var N = 10000;
        for (i in 0...N)
            total_turns += game.play();
        var avg = total_turns / N;
        Sys.println('Player lasted an average of $avg turns');
    }
}
