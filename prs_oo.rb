=begin
  
 Maybe make a ScoreBoard class that takes the player scores. Scoreboard can output and format the score. Scoreboard can
 show the winner too if it's told the winner's name.

 RPSGame class still determines winner. Sends info to ScoreBoard instance for formatting and output.

=end

require 'pry'

class ScoreBoard

  def initialize(name_one, name_two)
    @name_one = name_one
    @name_two = name_two

    @scores = {
      name_one => 0,
      name_two => 0
    }
  end

  def increase_score(player_name)
    @scores[player_name] += 1
  end

  def display_score
    @scores.each do |name, score|
      puts "#{name} has #{score} points"
    end
  end

  def winner?
    @scores.values.any? { |score| score.eql?(10) }
  end

  def get_winner
    @scores.key(10)
  end
end

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
  attr_accessor :move, :name
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
  attr_accessor :human, :computer, :score_board

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score_board = ScoreBoard.new(human.name, computer.name)
  end

  def display_welcome_message
    puts "Hi #{human.name}! Welcome to Rock, Paper, Scissors!"
  end

  def display_player_choices
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    human_name = human.name
    computer_name = computer.name
    if human.move > computer.move
      puts "#{human_name} won!"
      score_board.increase_score(human_name)
    elsif human.move < computer.move
      puts "#{computer_name} won!"
      score_board.increase_score(computer_name)
    else
      puts "It's a tie."
    end
  end

  def display_overall_winner
    puts "#{score_board.get_winner} is the overall winner!"
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
    score_board.display_score

    loop do
      human.choose
      computer.choose
      display_player_choices
      display_winner
      sleep 2

      system('cls') || system('clear')
      score_board.display_score
      break if score_board.winner?      
      break unless play_again?
    end
    system('cls') || system('clear')     
    display_overall_winner
  end
end

system('cls') || system('clear') 
RPSGame.new.play
