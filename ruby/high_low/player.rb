class Player
    def human?
        raise "NotImplemented"
    end

    def make_guess card
        raise "NotImplemented"
    end
    
    def self.get_player player_type
        case player_type
        when 'human'
            HumanPlayer.new
        when 'ai_rank'
            AIRankReflex.new
        when 'ai_constant'
            AIConstantGuess.new
        end
    end
end

class AIConstantGuess < Player
    def human?
        false
    end

    def make_guess card
        'higher'
    end
end

# Reflex Agent that looks at the current
# card. If it's in the low half of the ranks,
# choose "higher", otherwise choose "lower". If in
# the middle, just pick "higher"
class AIRankReflex < Player
    def human?
        false
    end

    def make_guess card
        min_rank = card.min_rank.value
        max_rank = card.max_rank.value
        midpoint = (min_rank + max_rank) / 2.0;
        if (card.rank.value > midpoint)
            return "lower";
        else
            return "higher"
        end
    end
end

class HumanPlayer < Player
    def human?
        true
    end

    def make_guess card
        guess = ""
        puts "You have card #{card}"
        until ["higher", "lower", "the same"].include? guess
            puts "Will the next card be ____{higher,lower,the same}?"
            print "> "
            guess = STDIN.gets.rstrip.downcase
        end
        guess
    end 
end
