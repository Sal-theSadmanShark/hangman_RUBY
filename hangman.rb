$stdout.sync = true
require 'json'

class Hangman

  attr_reader :live, :turns, :save_slot
  def initialize(word, save_slot,  used = [], unmatched = [], turns = 6, round = 0, storage = 0)
    @word = word.split("")
    @save_slot = save_slot.freeze
    storage == 0 ? @storage = Array.new(word.length) { |i| i = '_' } : @storage = storage
    @used = used
    @unmatched = unmatched
    @turns = turns
    @round = round
    @live = true
  end

  def play_turn
    @round = @round + 1

    puts 'please write your guess -'
    input = gets.chomp

    until verify_input(input)
      input = gets.chomp
    end

    return nil if input.size > 1 && special_input_case(input)

    unless check_similarities(input)
      @turns = turns - 1
    end

    show_game_state

    endgame

    nil
  end

  def show_game_state
    puts
    show_board
    show_stats
    draw_stickman
    puts
  end

  def save
    File.open(@save_slot, "w") { |file| file.puts to_json  }
  end

  def self.load(string)
    from_json(string)
  end

  def self.public_decode(array)
    self.decode(array).join
  end


  private

  def to_json
    JSON.dump ({
      :word => encode(@word),
      :save_slot => @save_slot,
      :storage => @storage,
      :used => @used,
      :unmatched => @unmatched,
      :turns => @turns,
      :round => @round
    })
  end

  def self.from_json(string)
    data = JSON.load(string)
    self.new(public_decode(data['word']),data['save_slot'], data['used'], data['unmatched'], data['turns'], data['round'], data['storage'])
  end

  def encode(a)
    a.map { |e| e = e.ord + 36 }.reverse
  end

  def self.decode(a)
    a.map { |e| e = (e - 36).chr }.reverse
  end

  def show_board
    @storage.each { |c| print c + " " }
    puts
  end

  def show_unmatched
    @unmatched.each { |c| print c + ", " }
    puts
  end

  def endgame
    if @turns == 0
      puts
      puts "you've lost !"
      puts "the word was - #{@word.join} "
      puts
      puts ".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  ."
      puts
    elsif @storage.join == @word.join
      @turns = 0
      puts
      puts "congratulations !!"
      puts "you've won"
      puts
      puts ".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  ."
      puts
    end
  end

  def draw_stickman
    case @turns
      when 6
        print %{
        _____.
             |
             |
             |
             |
        }
      when 5
        print %{
        _____.
         O   |
             |
             |
             |
        }
      when 4
        print %{
        _____.
         O   |
         |   |
             |
             |
        }
      when 3
        print %{
        _____.
         O   |
        /|   |
             |
             |
        }
      when 2
        print %{
        _____.
         O   |
        /|\\  |
             |
             |
        }
      when 1
        print %{
        _____.
         O   |
        /|\\  |
        /    |
             |
        }
      when 0
        print %{
        _____.
         O   |
        /|\\  |
        / \\  |
             |
        }
    end
  puts
  end

  def show_stats
    puts
    puts "round num - #{@round}"
    puts "guesses left - #{@turns}"
    puts "misses - "
    show_unmatched
    puts
  end

  def verify_input(input)
    if input == 'quit' || input == 'save' || input == 'pause'
      return true
    elsif input.size == 1 && 'a' <= input && input <= 'z'
      if @used.include? input
        puts 'input has alreary been used, try again -'
        return false
      end
      return true
    end
    puts 'invalid input , please write a lowercase letter -'
    return false
  end

  def special_input_case(input)
    case input
    when "quit"
      @live = false
      @turns = 0
    when "save"
      save
      puts
      puts "-  -  - the game has been saved -  -  -"
      puts
    when "pause"
      save
      puts
      puts "-  -  - the game has been saved -  -  -"
      puts
      @live = false
      @turns = 0
    end
    true
  end

  def check_similarities(input)
    found = false
    @used.push(input)
    @word.each_with_index do |char,index|
      if char == input
        @storage[index] = input
        found = true
      end
    end
    if found == false
      @unmatched.push(input)
    end
    found
  end

end
