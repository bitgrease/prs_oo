require 'pry'

class GameHistory
  MOVE_KEYS = %w[spock lizard paper rock scissors]

  def initialize
    @history = {}
    @history[:human] = Array.new(MOVE_KEYS.size,0)
    @history[:computer] = Array.new(MOVE_KEYS.size,0)
  end

  def update(human_move, computer_move)
    @history[:computer][MOVE_KEYS.index(computer_move.value)] += 1
    @history[:human][MOVE_KEYS.index(human_move.value)] += 1
  end

  def get_history
    self.to_s
  end

  def to_s
    @history.keys.each do |player|
      puts "#{player.to_s.capitalize} moves:"
      MOVE_KEYS.each_with_index do |move, idx|
        puts "#{move} -> #{@history[player][idx]}"
      end
    end
  end
end

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

  def winner_name
    @scores.key(10)
  end
end

class Move
  attr_reader :value
  VALUES = %w[rock paper scissors lizard spock]
  WINNING_MOVES = {
    'spock' => %w[rock scissors],
    'scissors' => %w[lizard paper],
    'paper' => %w[spock rock],
    'rock' => %w[paper lizard],
    'lizard' => %w[paper spock]
  }

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WINNING_MOVES[value].include?(other_move.value)
  end

  def <(other_move)
    WINNING_MOVES[other_move.value].include?(value)
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
      puts "Please choose rock, paper, scissors, lizard or spock:"
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
  attr_accessor :human, :computer, :score_board, :game_history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score_board = ScoreBoard.new(human.name, computer.name)
    @game_history = GameHistory.new
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
    human_move = human.move
    computer_move = computer.move

    if human_move > computer_move
      puts "#{human_name} won!"
      score_board.increase_score(human_name)
    elsif human_move < computer_move
      puts "#{computer_name} won!"
      score_board.increase_score(computer_name)
    else
      puts "It's a tie."
    end
  end

  def display_overall_winner
    puts "#{score_board.winner_name} is the overall winner!"
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

  def play_single_round
    human.choose
    computer.choose
    display_player_choices
    display_winner
    game_history.update(human.move, computer.move)
    sleep 2
  end

  def play
    display_welcome_message
    score_board.display_score

    loop do
      play_single_round
      binding.pry
      system('cls') || system('clear')
      score_board.display_score
      break unless !score_board.winner? || play_again?
    end
    system('cls') || system('clear')
    display_overall_winner
  end
end

system('cls') || system('clear')
RPSGame.new.play
