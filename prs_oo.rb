=begin
  
 Maybe make a ScoreBoard class that takes the player scores. Scoreboard can output and format the score. Scoreboard can
 show the winner too if it's told the winner's name.

 RPSGame class still determines winner. Sends info to ScorBoard instance for formatting and output.

=end
  
end


require 'pry'
class Move
  VALUES = %w[rock paper scissors]

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

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    self.score = 0
  end
end

class Human < Player
  def initialize
    super
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
    self.name = name
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
    super
    set_name
  end

  def set_name
    self.name = %w[R2D2 C3PO Computer Hal].sample
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
    puts "Hi #{human.name}! Welcome to Rock, Paper, Scissors!"
  end

  def display_score
    if (human.score == computer.score)
      puts "Sorry, no winner. It was a tie."
      return
    end

    winner = human.score > computer.score ? human : computer

    p "Score was #{human.name} : #{human.score}"
    puts " and #{computer.name} : #{computer.score}"
    puts "#{winner.name} wins!"
  end

  def display_player_choices
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      human.score += 1
    elsif human.move < computer.move
      puts "#{computer.name} won."
      computer.score += 1
    else
      puts "It's a tie."
    end
  end

  def display_overall_winner
    puts "#{[human, computer].find {|p| p.score == 10}.name} is the overall winner!"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again, #{human.name}? (y/n)"
      answer = gets.chomp
      break if %w[y n].include? answer.downcase
      puts 'Sorry, must be y or n.'
    end
    answer.eql?('y')
  end

  def overall_winner?
    (human.score == 10) || (computer.score == 10)
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_player_choices
      display_winner
      binding.pry
      break if overall_winner?
      break unless play_again? 
      display_score
    end
    display_score
    display_overall_winner
  end
end

RPSGame.new.play
