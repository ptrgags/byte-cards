class GameConsole
    def initialize interactive
        @interactive = interactive
    end

    def println message, interactive_only=true
        if not interactive_only or @interactive
            puts message
        end
    end

    def prompt_line prompt
        if not @interactive
            raise "Not in interactive mode!"
        else
            print prompt
            STDIN.gets.strip
        end
    end
end
