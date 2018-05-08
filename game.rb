
class Game

  attr_accessor :current_player, :player1, :player2

  def initialize(player1_name, player2_name, difficulty, turn, computer1_level, computer2_level)
      @@board = Board.new

      if player1_name == "Computer1"
        @player1 = Computer.new(player1_name, "X", "O", computer1_level)
      else
        @player1 = Human.new(player1_name, "X")
      end
      puts "Player1 is #{@player1}"

      if player2_name == "Computer"
        @player2 = Computer.new(player2_name, "O", "X", difficulty)
      elsif player2_name == "Computer2"
        @player2 = Computer.new(player2_name, "O", "X", computer2_level)
      else
        @player2 = Human.new(player2_name, "O")
      end
      puts "Player2 is #{@player2}"

      if turn == "player1"
        @turn = "player1"
        @current_player = @player1
      else
        @turn = "player2"
        @current_player = @player2
      end
  end

  def board_state
    @@board.state
  end

  def overall_status
    @@board.overall_status
  end

  # def board_overall_status
  #   @board.overall_status
  # end

  def turn
    @turn
  end


  def update_game_status(move)
    if @@board.check_position(move) == false
      return "no_dice"
    else
      @@board.change_state(@current_player.piece, move)
    end

    if @@board.check_winner
      @current_player.increase_score
      return "winner"
    elsif @@board.check_tie
      return "tie"
    else
      puts "It should be changing here"
      puts "@current_player is #{@current_player}"
      @current_player = @current_player ==  @player1 ? @player2 : @player1
      @turn = @turn == "player1" ? "player2" : "player1"
    end
  end


  def play_again(turn)
    @@board = Board.new
    @@board.reset
    @turn = turn
    if turn == "player1" || turn == "Computer1"
      @current_player = @player1
    else
      @current_player = @player2
    end
  end

end
