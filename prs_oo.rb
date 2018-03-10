class GameHistory
  attr_reader :player_name, :game_results
  def initialize(player_name)
    @player_name = player_name
    @game_results = {
      wins: [],
      losses: []
    }
  end

  def update(winner_name, move)
    if player_name.eql?(winner_name)
      game_results[:wins] << move.value
    else
      game_results[:losses] << move.value
    end
  end

  def move_loss_rate(move)
    num_move_losses = @game_results[:losses].select do |losing_move|
      losing_move.eql?(move)
    end.size

    total_games = game_results[:wins].size + game_results[:losses].size
    if total_games.zero?
      0
    else
      num_move_losses / (Float total_games)
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
    'rock' => %w[scissors lizard],
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

class Spock < Move
  def initialize
    @value = 'spock'
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
  end
end

class Rock < Move
  def initialize
    @value = 'rock'
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
  end
end

class Player
  attr_accessor :move, :name
  def initialize
    @moves = {
      'spock' => Spock.new,
      'lizard' => Lizard.new,
      'rock' => Rock.new,
      'paper' => Paper.new,
      'scissors' => Scissors.new
    }
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
      break unless name =~ /\s/ || name.empty?
      puts "Sorry, you must enter a valid name (no white space chars allowed)."
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
    self.move = @moves[choice]
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

  def choose(history, player_move)
    case name
    when 'R2D2' then self.move = Move.new('rock')
    when 'Hal' then self.move = hal_choice(player_move)
    else
      self.move = @moves[Move::VALUES.sample]
      weighted_moves = Move::VALUES.dup * 2
      until history.move_loss_rate(move.value) < 0.6
        weighted_moves.delete_at(weighted_moves.index(move.value))
        self.move = weighted_moves.sample
      end
    end
    move
  end

  def hal_choice(player_move)
    Move::WINNING_MOVES.keys.each do |move_option|
      if Move::WINNING_MOVES[move_option].include?(player_move)
        return Move.new(move_option)
      end
    end
  end
end

class RPSGame
  attr_accessor :human, :computer, :score_board, :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score_board = ScoreBoard.new(@human.name, @computer.name)
    @history = GameHistory.new(computer.name)
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
      update_scoreboard_and_history(human_name, computer_move)
    elsif human_move < computer_move
      puts "#{computer_name} won!"
      update_scoreboard_and_history(computer_name, computer_move)
    else
      puts "It's a tie."
    end
  end

  def update_scoreboard_and_history(winner_name, computer_move)
    score_board.increase_score(winner_name)
    history.update(winner_name, computer_move)
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
    computer.choose(history, human.move.value)
    display_player_choices
    display_winner
    sleep 2
  end

  def play
    display_welcome_message
    score_board.display_score

    loop do
      play_single_round
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
