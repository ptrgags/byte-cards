require_relative "game"
require_relative "player"

player = Player.get_player 'human'
game = HighLowGame.new player, 'fruit'
game.play
