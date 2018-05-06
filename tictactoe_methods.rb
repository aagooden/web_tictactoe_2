

class Game

  def initialize(number_of_players, player1, player2, difficulty)
      @board = Board.new

      @number_of_players = number_of_players

      @player1 = Player.new(player1, "X")#, @board)

      if @number_of_players == "2"

        @player2 = Player.new(player2, "O")#, @board)

        @turn = true
      else
        player2 = "Computer"
        @player2 = Computer.new(player2, "O")#, @board)
        # This is where @player2 is assigned to computer

        @turn = true

        @difficulty = difficulty
      end
  end

  def board_state
    puts "This is @board.state from game #{@board.state}"
    @board.state

  end

  def turn
    @turn
  end

  def player2_class
    @player2.class
  end

  def play(current_move)

    player = ""

    if @turn == true
        player = @player1
    else
        player = @player2

    end

		if player.class == Computer
      position =
        [player.random_move(@board.state, @player2.piece, @player1.piece),
        player.sequential_move(@board.state, @player2.piece, @player1.piece),
        player.move(@board.state)][@difficulty.to_i - 1]
		else
      position = current_move
      position = position.to_i
		end

    @board.change_state(player.piece, position)
    player.update_positions(position)

    @turn = !@turn

    if player.check_winner == true
      player.increase_score
      return player.name, @player1.name, @player1.score, @player2.name, @player2.score, "winner"
    elsif @board.check_tie
      return player.name, @player1.name, @player1.score, @player2.name, @player2.score, "tie"
    end

    return player.name, @player1.name, @player1.score, @player2.name, @player2.score, "none"
  end

  def play_again(turn)
    @board = Board.new
    @player1.positions=([])
    @player2.positions=([])
    @turn = turn
  end

end


class Board

    def initialize(state=[1,2,3,4,5,6,7,8,9])
        @state = state
    end

		def state
			@state
		end

    def change_state(piece, position)
        @state[position-1] = piece
    end

    def check(position)
        if @state[position -1] == "X" || @state[position -1] == "O"
            false
        else
            true
        end
    end

    def check_tie
        @state.all? {|i| i.is_a?(String) }
    end

end


class Player

    attr_accessor :name, :piece

    def initialize(name, piece) #board)
        @piece = piece
        @name = name
				# @board = board
        @score = 0
        @positions = []
    end

    def update_positions(position)
        @positions.push(position-1)
    end

    def positions
        @positions
    end

    def positions=(new)
        @positions = new
    end

    def increase_score
        @score +=1
    end

    def score
        @score
    end

    def check_winner
      winner = false
      winning_combinations = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]]
      winning_combinations.each do |group|
        contain = 0
        group.each do |num|
          if positions.include?(num)
            contain+=1
        	end
          if contain == 3
            winner = true
          end
        end
      end
      return winner
    end

end


class Computer < Player

  def winning_move(overall_status,move)
    overall_status.each do |temp|
      #check for winning move and play winning move
      if temp.count(self.piece) == 2
        group = temp - [@opponent_piece, piece]
        if group.empty?
        else
          move = group[0]
        end
      end
    end
    return move
  end


  def block(overall_status,move)
    group = []
    #check for opponent winning position and block
    overall_status.each do |temp|
    if temp.count(@opponent_piece) == 2
        group = temp - [@opponent_piece, self.piece]
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


  def fork_block(overall_status, move, piece, opponent_piece)
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
    #This is accomplished by deleting the fork_block moves from the possible moves below
    possible.each do |num|
      if two_in_a_row.include?(num)
        # puts "This is two_in_a_row when comparing to possible fork_block moves #{two_in_a_row}"
        two_in_a_row_block.push(num)
      end
    end

    if two_in_a_row_block.length > 1
      two_in_a_row = two_in_a_row - two_in_a_row_block
    end

    #This is two_in_a_row without possible fork_block moves
    #if there are more than one possibility left, just pick one randomly
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


  def random_move(board_state, piece, opponent_piece)
  #This function picks a random empty spot on the board and plays there
    @opponent_piece = opponent_piece
    move = ""
    # puts "WELCOME TO RANDOM MOVE...ENJOY YOUR STAY!"
    board = board_state
    overall_status = []
    combos = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]]
      combos.each do |group|
        temp = []
          group.each do |position|
            temp.push(board[position])
          end
          overall_status.push(temp)
      end
      #This conditional allows computer to check for a winning move making it a "little" smarter
    if move == ""
      move = winning_move(overall_status,move)
    end

    if move == ""
      board = board - [opponent_piece]
      board = board - [piece]
      # This is board after deleting pieces
      move = board.sample
    end
    return move
  end


  def sequential_move(board_state, piece, opponent_piece)
      @opponent_piece = opponent_piece
    move = ""
    board = board_state
    overall_status = []
    combos = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]]
      combos.each do |group|
        temp = []
          group.each do |position|
            temp.push(board[position])
          end
          overall_status.push(temp)
      end
    if move == ""
      # puts "Sending to winning move"
      move = winning_move(overall_status,move)
    end

    if move == ""
      board = board_state
      board = board - [opponent_piece]
      board = board -[piece]
        move = board.first
    end
    return move
  end


  def move(board_state)
    # puts "HITTING THE MOVE FUNCTION"
    move = ""
    board = Array.new
    if self.piece == "O"
      @opponent_piece = "X"
    else
      @opponent_piece = "O"
    end
    #if the following routine is not performed, any changes in a variable set to @board.state will subsequently change @board.state...
    # This is essentially insulating @board.state from changes
    board_state.each do |position|
      board.push(position)
    end

    overall_status = []
    combos = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]]
      combos.each do |group|
        temp = []
          group.each do |position|
            temp.push(board[position])
          end
          overall_status.push(temp)
      end

    # These method calls, call each individual method that makes up the "unbeatable" strategy for the computer
    computer_move =
      [winning_move(overall_status, move),
      block(overall_status, move),
      fork_move(overall_status, move, self.piece, @opponent_piece),
      fork_block(overall_status, move, self.piece, @opponent_piece),
      play_center(board,move),
      play_opposite_corner(board, move, self.piece, @opponent_piece),
      empty_corner(board, move),
      empty_edge(board,move)]

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
