require_relative "game"
require_relative "player"
require_relative "../byte_cards/console.rb"

player = Player.get_player 'ai_rank'
console = GameConsole.new player.human?
game = HighLowGame.new player, 'playing_card', console
game.play
