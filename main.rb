require_relative 'hangman.rb'

# essential methods
def pick_word
  count = IO.readlines('word_list.txt').size.freeze
  word = read_line( rand count )
  until 5 <= word.size && word.size <= 12
    word = read_line( rand count )
  end
  word
end

def read_line(line)
  IO.readlines('word_list.txt')[line].chomp
end

def start_new_game
  Hangman.new(pick_word, 'saves.json')
end

def load_game
  save = File.open('saves.json', 'r'){ |file| file.gets.chop }
  Hangman.load(save)
end

def instructions
  puts
  puts 'instructions - '
  print %{
    welcome to hangamn.
    visit [https://en.wikipedia.org/wiki/Hangman_(game)] for about the rules
    you can write -
     'save' to save the game
     'quit' to exit the game
     'pause' to save and exit
    before starting the game,
    you can load and start again where you previously left off

    ` press enter to continue `
  }
  puts
  buffer = gets.chomp
  puts buffer
end

def play_outro
  puts
  puts
  print %{
    thanks for playing
    :D
  }
end

def play_a_round(game)
  until game.turns == 0
    game.play_turn
    break unless game.live
  end
end

# main game starts
puts
puts
puts %{__Hangman__}
print %{
  1.new game
  2.load game
  3.instructions
}
puts
print "input - "

n = gets.chomp.to_i
until 1 <= n && n <= 3
  print 'plaese try again - '
  n = gets.chomp.to_i
end

case n
when 1
  game = start_new_game
when 2
  game = load_game
  puts
  puts "- - previously saved game have been loaded - -"
  puts
when 3
  instructions
  game = start_new_game
end

puts
puts "game starts :- "
puts

game.show_game_state

loop do
  play_a_round(game)
  break unless game.live
  game = start_new_game
  game.show_game_state
end

play_outro
