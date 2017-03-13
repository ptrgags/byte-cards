package high_low;

import high_low.HighLowGame;

typedef Config = {
    var player_type:String;
    var num_games:Int;
}

class ConfigLoader {
    private var fname:String;

    public function new(fname:String) {
        this.fname = fname;
    }

    public function load():Config {
        var json = sys.io.File.getContent(fname);
        var conf:Config = haxe.Json.parse(json);
        return conf;
    }
}

class Main {
    static public function main():Void {
        //Load config
        var conf_fname = Sys.args()[0];
        var loader = new ConfigLoader(conf_fname);
        var config = loader.load();

        //Play games over and over again
        var game = new HighLowGame();
        var total_turns = 0.0;
        var N = config.num_games;
        for (i in 0...N) {
            Sys.println('== Game ${i + 1} ======================');
            total_turns += game.play();
        }
        var avg = total_turns / N;
        Sys.println('Player lasted an average of $avg turns');
    }
}
