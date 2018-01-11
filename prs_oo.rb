require 'pry'
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

class Move
  VALUES = %w(rock paper scissors)

  def initialize(value)
    @value = value
  end

  def scissors?
    @value.eql?('scissors')
  end

  def rock?
    @value.eql?('rock')
  end

  def paper?
    @value.eql?('paper')
  end

  def > (other_move)
    if rock?
      return true if other_move.scissors?
      return false
    elsif paper?
      return true if other_move.rock?
      return false
    else scissors?
      return true if other_move.paper?
      return false
    end
  end

  def < (other_move)
    if rock?
      return true if other_move.paper?
      return false
    elsif paper?
      return true if other_move.scissors?
      return false
    else scissors?
      return true if other_move.rock?
      return false
    end
  end

  def to_s
    @value
  end
end


class Player
  attr_accessor :move, :player_name
end

class Human < Player
  def initialize
    set_name
  end

  def set_name
    name = nil
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, you must enter a value."
    end
    self.player_name = name
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp.downcase  
      break if Move::VALUES.include?(choice)
      puts 'Sorry, invalid choice'
    end
    self.move = Move.new(choice)
  end
end



class Computer < Player
  def initialize
    set_name
  end

  def set_name
    self.player_name = %w(R2D2 C3PO Computer Hal).sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer 
  
  def initialize
    @human = Human.new
    @computer = Computer.new
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

    if human.move > computer.move
      puts "#{human.player_name} won!"
    elsif human.move < computer.move
      puts "#{computer.player_name} won."
    else
      puts "It's a tie."
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
