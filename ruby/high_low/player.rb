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
        while not ["higher", "lower", "the same"].include? guess
            puts "Will the next card be ____{higher,lower,the same}?"
            print "> "
            guess = STDIN.gets.rstrip.downcase
        end
        guess
    end 
end
