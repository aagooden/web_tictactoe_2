
class Game

  attr_accessor :current_player, :player1, :player2

  def initialize(player1_name, player2_name, difficulty, turn, computer1_level, computer2_level)
      @@board = Board.new

      if player1_name == "Computer1"
        @player1 = Computer.new(player1_name, "X", "O", computer1_level)
      else
        @player1 = Human.new(player1_name, "X")
      end

      if player2_name == "Computer"
        @player2 = Computer.new(player2_name, "O", "X", difficulty)
      elsif player2_name == "Computer2"
        @player2 = Computer.new(player1_name, "O", "X", computer2_level)
      else
        @player2 = Human.new(player2_name, "O")
      end

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
      @current_player = @current_player ==  @player1 ? @player2 : @player1
      @turn = @turn == "player1" ? "player2" : "player1"
    end
  end


    # player = ""

    # if @turn == true
    #     player = @player1
    # else
    #     player = @player2
    #
    # end

		# if player.class == Computer
    #   position =
    #     [player.random_move(@board.state, @player2.piece, @player1.piece),
    #     player.sequential_move(@board.state, @player2.piece, @player1.piece),
    #     player.move(@board.state)][@difficulty.to_i - 1]
		# else
    #   position = current_move
    #   position = position.to_i
		# end
  #
  #   @board.change_state(player.piece, position)
  #   player.update_positions(position)
  #
  #   @turn = !@turn
  #
  #   if player.check_winner == true
  #     player.increase_score
  #     return player.name, @player1.name, @player1.score, @player2.name, @player2.score, "winner"
  #   elsif @board.check_tie
  #     return player.name, @player1.name, @player1.score, @player2.name, @player2.score, "tie"
  #   end
  #
  #   return player.name, @player1.name, @player1.score, @player2.name, @player2.score, "none"
  # end

  def play_again(turn)
    @@board = Board.new
    @@board.state = [1,2,3,4,5,6,7,8,9]
  end

end
