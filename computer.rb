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





  # puts "HITTING THE MOVE FUNCTION"
  # move = ""
  # board = Array.new
  # if self.piece == "O"
  #   @opponent_piece = "X"
  # else
  #   @opponent_piece = "O"
  # end
  # #if the following routine is not performed, any changes in a variable set to @board.state will subsequently change @board.state...
  # # This is essentially insulating @board.state from changes
  # board_state.each do |position|
  #   board.push(position)
  # end






end
