class Unbeatable

  def winning_move(overall_status,move,piece,opponent_piece)
    overall_status.each do |temp|
      #check for winning move and play winning move
      if temp.count(piece) == 2
        group = temp - [opponent_piece, piece]
        if group.empty?
        else
          move = group[0]
        end
      end
    end
    return move
  end


  def block(overall_status,move,piece,opponent_piece)
    group = []
    #check for opponent winning position and block
    overall_status.each do |temp|
    if temp.count(opponent_piece) == 2
        group = temp - [opponent_piece, piece]
        if group.empty?
        else
          move = group[0]
        end
      end
    end
    return move
  end


  def fork_move(overall_status, move, piece, opponent_piece)
    forks = []
    positions = []
    possible =[]

    overall_status.each do |temp|
      if temp.count(piece) == 1 && temp.include?(opponent_piece) == false
        group = temp - [piece]
          forks.push(group)
      end
    end

    forks.each do |element|
      element.each do |n|
        positions.push(n)
      end
    end

    #construct an array of possible fork moves
    for x in (1..9) do
      num = positions.count(x)
      if num > 1
        possible.push(x)
      end
    end

    #if no possible moves...return move
    if possible.empty?
      return move
    else
      move = possible.sample
      return move
    end

  end


  def create_two_in_a_row(overall_status, move, piece, opponent_piece)
    possible_two_in_a_row = []
    positions = []
    #if there is an empty location that creates a two-in-a row for computer(thus forcing opponent to block), play in that location
    #else move to the empty intersection space
    overall_status.each do |combo|
      if combo.count(piece) == 1 && combo.include?(opponent_piece) == false
        possible_two_in_a_row.push(combo)
      end
    end

    possible_two_in_a_row.each do |row|
      row.each do |n|
        positions.push(n)
      end
    end

    positions = positions - [piece]
    return positions
  end


  def fork_block(overall_status, board_state, move, piece, opponent_piece)
    forks = []
    positions = []
    possible =[]
    two_in_a_row_block = []

    #find all the POSSIBLE opponent fork moves.  These are any three spaces in a row that contains one opponent piece.  This should create an array of arrays with two positions each because the position containing the opponent piece is deleted.
    overall_status.each do |temp|
      if temp.count(opponent_piece) == 1 && temp.include?(piece) == false
        group = temp - [opponent_piece] #This deletes the space that contains opponent piece.
          forks.push(group)
      end
    end

    #constructs an array of possible positions from forks array above.
    forks.each do |element|
      element.each do |n|
        positions.push(n)
      end
    end

    #construct an array of possible actual fork moves...these are positions that repeat in the array.  In other words, where they overlap.
    for x in (1..9) do
      num = positions.count(x)
        # puts "The count for #{x} is #{num}"
      if num > 1
        possible.push(x)
      end
    end

    #If there is only one possible fork for the opponent, the player should block it.
    if possible.length == 1
      move = possible.first
      return move
    # Otherwise, the player should block any forks in any way that simultaneously allows them to create two in a row...this is accomplished with the create_two_in_a_row function
    elsif possible.length > 1
      #the following function call finds possible two_in_a_row moves
      two_in_a_row = create_two_in_a_row(overall_status, move, piece, opponent_piece)
    else
      return move
    end

    # Otherwise, the player should block any forks in any way that simultaneously allows them to create two in a row...

    test_move = ""
    two_in_a_row.each do |position|
      temp_board = []
      board_state.each do |x|
        temp_board.push(x)
      end
          temp_board[position-1] = piece

          temp_overall = []
          combos = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]]
            combos.each do |group|
              temp = []
                group.each do |num|
                  temp.push(temp_board[num])
                end
                temp_overall.push(temp)
            end

            temp_overall.each do |group_3|
              if group_3.count(piece) == 2
                puts "This is group_3 #{group_3}"
                  array = group_3 - [piece]
                    test_move = array[0]
              end
            end

      if possible.include?(test_move)
        two_in_a_row = two_in_a_row - [position]
      end

    end

    move = two_in_a_row.sample
    return move

  end


  def play_center(board,move)
  #if center is available, play there
    if board[4] == 5
      move = 5
    end
    return move
  end


  def play_opposite_corner(board,move, piece, opponent_piece)
  #if opposite corner is available (opposite from corner played by opponent) play there
    corner_opposites = [[0,9],[2,7],[8,1],[6,3]]
    corner_opposites.each do |pair|
      if board[pair[0]] == opponent_piece && board[pair[1]-1] == pair[1]
        move = pair[1]
      end
    end
    return move
  end


  def empty_corner(board, move)
    #if corner is empty, play there
    corners = [0, 2, 6, 8]
    corners.each do |corner|
      if board[corner] == corner + 1
        move = corner + 1
      end
    end
    return move
  end


  def empty_edge(board, move)
  #if corner is empty, play there
    edges = [1, 3, 5, 7]
    edges.each do |edge|
      if board[edge] == edge + 1
        move = edge + 1
      end
    end
    return move
  end

  def move(board_state, overall_status, piece, opponent_piece)
    move = ""
    # These method calls, call each individual method that makes up the "unbeatable" strategy for the computer
    computer_move =
      [winning_move(overall_status, move, piece, opponent_piece),
      block(overall_status, move, piece, opponent_piece),
      fork_move(overall_status, move, piece, opponent_piece),
      fork_block(overall_status, board_state,move, piece, opponent_piece),
      play_center(board_state,move),
      play_opposite_corner(board_state, move, piece, opponent_piece),
      empty_corner(board_state, move),
      empty_edge(board_state,move)]

    computer_move.each do |func|
      if func == ""
      else
        move = func
        break
      end
    end

    #Here is the final move
    return move
  end

end
