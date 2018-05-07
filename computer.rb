class Computer


  attr_accessor :name, :piece

  def initialize(name, piece, opponent_piece, difficulty)
      @piece = piece
      @name = "Computer"
      @score = 0
      @opponent_piece = opponent_piece
      @level = [Random.new, Sequential.new, Unbeatable.new][difficulty - 1]
      puts "&*********&&&&&&&&&&**********&&&&&&&The level is #{@level}"
  end

  def increase_score
      @score +=1
  end

  def score
      @score
  end

  def move(board_state, overall_status)
    computer_move = @level.move(board_state, overall_status, @piece, @opponent_piece)
  end

end
