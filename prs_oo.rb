# Paper Rock Scissors
# User makes choice
# Computer makes choice
# Winner is displayed

=begin
  LS Description:
  Rock, Paper, Scissors is a two-player game where each player chooses
one of three possible moves: rock, paper, or scissors. The chosen moves
will then be compared to see who wins, according to the following rules:

- rock beats scissors
- scissors beats paper
- paper beats rock

If the players chose the same move, then it's a tie.

Nouns: player, move, rule
Verbs: choose, compare

Player
- choose
Move
Rule

-compare
=end


class Player
  attr_accessor :move, :player_name
  attr_reader :player_type

  def initialize(player_type = :human)
    @player_type = player_type
    @player_name
    @move = nil
    set_name
  end

  def set_name
    if human?
      name = nil
      loop do
        puts "What's your name?"
        name = gets.chomp
        break unless name.empty?
        puts "Sorry, you must enter a value."
      end
      self.player_name = name
    else
      self.player_name = %w(R2D2 C3PO Computer Hal).sample
    end
  end

  def human?
    player_type.eql?(:human)
  end

  def choose
    if human?
      choice = nil
      loop do
        puts "Please choose rock, paper, or scissors:"
        choice = gets.chomp
        break if %w(rock paper scissors).include?(choice)
        puts 'Sorry, invalid choice'
      end
      self.move = choice
    else
      self.move = %w(rock paper scissors).sample
    end
  end
end

class RPSGame
  attr_accessor :human, :computer 
  
  def initialize
    @human = Player.new
    @computer = Player.new(:computer)
  end

  def display_welcome_message
    puts "Hi #{human.player_name}! Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, #{human.player_name}!"
  end

  def display_winner
    puts "#{human.player_name} chose #{human.move}."
    puts "#{computer.player_name} chose #{computer.move}"
    case human.move
    when 'rock'
      puts "It's a tie!" if computer.move.eql?('rock')
      puts "#{human.player_name} won!" if computer.move.eql?('scissors')
      puts "#{computer.player_name} won!" if computer.move.eql?('paper')
    when 'paper'
      puts "It's a tie!" if computer.move.eql?('paper')
      puts "#{human.player_name} won!" if computer.move.eql?('rock')
      puts "#{computer.player_name} won!" if computer.move.eql?('scissors')
    when 'scissors'
      puts "It's a tie!" if computer.move.eql?('scissors')
      puts "#{human.player_name} won!" if computer.move.eql?('paper')
      puts "#{computer.player_name} won!" if computer.move.eql?('rock')
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again, #{human.player_name}? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts 'Sorry, must be y or n.'
    end
    answer.eql?('y')
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
      display_goodbye_message
    end
  end
end

RPSGame.new.play
