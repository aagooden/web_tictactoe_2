class Sequential

  def move(board_state, overall_status, piece, opponent_piece)
    # puts "HITTING SEQUENTIAL MOVE FUNCTION"
    # move = ""
    # board = board_state
    # overall_status = []
    # combos = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]]
    #   combos.each do |group|
    #     temp = []
    #       group.each do |position|
    #         temp.push(board[position])
    #       end
    #       overall_status.push(temp)
    #   end


    # if move == ""
    #   # puts "Sending to winning move"
    #   move = winning_move(overall_status,move)
    # end

    # if move == ""
      board = board_state
      board = board - [opponent_piece]
      board = board -[piece]
        move = board.first
    # end
    return move
  end

end
