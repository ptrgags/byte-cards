GAMES = ['high_low', 'war']

if GAMES.include? ARGV[0]
    require_relative "#{ARGV[0]}/main"
else
    game_str = GAMES.join ','
    puts "Usage: ruby main.rb {#{game_str}}"
end
