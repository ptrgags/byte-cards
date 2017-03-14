package high_low;

import high_low.Player;

class PlayerSelect {
    public function new() {}

    public function get_player(player_type:String):IPlayer {
        if (player_type == "human")
            return cast new HumanPlayer();
        else if (player_type == "ai_constant")
            return cast new AIConstantGuess("higher");
        else if (player_type == "ai_rank")
            return cast new AIRankGuess();
        else
            return null;
    }
}
