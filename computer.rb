class Computer

@score
  attr_accessor :name, :piece, :opponent_piece, :level

  def initialize(name, piece, opponent_piece, difficulty)
      @piece = piece
      @name = name
      @score = 0
      @opponent_piece = opponent_piece
      @level = difficulty
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
