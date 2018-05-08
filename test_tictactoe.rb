require "minitest/autorun"
require_relative "game.rb"
require_relative "human.rb"
require_relative "computer.rb"
require_relative "board.rb"
require_relative "random.rb"
require_relative "sequential.rb"
require_relative "unbeatable.rb"

class Tictactoe_test < Minitest::Test

	def test_boolean
		assert_equal(true, true)
	end

	def test_new_game_board_state
	  @game=Game.new("Aaron", "Computer", 2, "player1", 1, 1)
		function = @game.board_state
	  assert_equal([1,2,3,4,5,6,7,8,9], function)
	end

	def test_check_winner_1
		@board = Board.new(["X",2,"O","O","O",6,"X","X","X"])
		# player = Player.new("Jack", "X", ["X",2,"O","O","O",6,"X","X","X"])
		# player.positions=([0,6,7,8])#player.positions uses index numbers instead of board space numbers
		function = @board.check_winner
		assert_equal(true, function)
	end

	def test_check_winner_2
		@board = Board.new(["X","O","X",4,"X","O","O",8,"X"])
		# player.positions=([0,2,4,8])#player.positions uses index numbers instead of board space numbers
		function = @board.check_winner
		assert_equal(true, function)
	end

	def test_check_board_position_1
		board = Board.new(["X","O","X",4,"X","O","O",8,"X"])
		function = board.check_position(4)
		assert_equal(true, function)
	end

	def test_check_board_position_2
		board = Board.new(["X","O","X",4,"X","O","O",8,"X"])
		function = board.check_position(5)
		assert_equal(false, function)
	end

	def test_check_board_position_3
		board = Board.new(["X","O","X",4,"X","O","O",8,"X"])
		function = board.check_position(8)
		assert_equal(true, function)
	end

	def test_check_tie_1
		board = Board.new(["X","O","X","O","X","O","X","O","X"])
		function = board.check_tie
		assert_equal(true, function)
	end

	def test_check_tie_2
		board = Board.new(["X","X","X","X","X","X","X","X","X"])
		function = board.check_tie
		assert_equal(true, function)
	end

	def test_winning_move
		# @board=Board.new
		state = ["O","X",3,"O","X","X",7,8,9]
		overall_status = [["O","X",2],["O","X","X"],[7,8,9],["O","O",7],["X","X",8],[3,"X",9],["O","X",9],[7,"X",3]]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.winning_move(overall_status,10,"O","X")
		assert_equal(7, function)
	end

	def test_winning_move_with_possible_block_present
		@board=Board.new
		state = ["X","X","O","O","O",6,"X",8,"X"]
		overall_status = [["X","X","O"],["O","O",6],["X",8,"X"],["X","O","X"],["X","O",8],["O",6,"X"],["X","O","X"],["X","O","O"]]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.winning_move(overall_status,"", "O", "X")
		assert_equal(6, function)
	end

	def test_block
		# @board=Board.new
		state = [1,2,"X",3,"X",6,7,8,"O"]
		overall_status = [[1,2,"X"],[3,"X",6],[7,8,"O"],[1,3,7],[2,"X",8],["X",6,"O"],[1,"X","O"],[7,"X","X"]]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.block(overall_status,"", "O", "X")
		assert_equal(7, function)
	end

	def test_block_2
		# @board=Board.new
		state = [1,"X","O",3,"X",6,7,"O","X"]
		overall_status=[[1,"X","O"],[3,"X",6],[7,"O","X"],[1,4,7],["X","X","O"],["O",6,"X"],[1,"X","X"],[7,"X","O"]]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.block(overall_status,"", "O", "X")
		assert_equal(1, function)
	end

	def test_fork_move_1
		# @board=Board.new
    overall_status = [[1,2,"X"],["X","O",6],["O",8,9],[1,"X","O"],[2,"O",8],["X",6,9],[1,"O",9],["O","O","X"]]
    # @player1 = Player.new("Aaron", "X", @board)
    # @player2 = Computer.new("Computer", "O", @board)
		possible = [8,9]
		@level = Unbeatable.new
		actual = @level.fork_move(overall_status, "", "O", "X")
		contain = possible.include?(actual)
    assert_equal(true, contain)
	end

  def test_fork_move_2
		# @board=Board.new
    overall_status = [[1,2,"O"],["O",5,"X"],[7,8,"X"],[1,"O",7],[2,5,8],["O","X","X"],[1,5,"X"],[7,5,"O"]]
    # @player1 = Player.new("Aaron", "X", @board)
    # @player2 = Computer.new("Computer", "O", @board)
		possible = [1,7]
		@level = Unbeatable.new
		actual = @level.fork_move(overall_status, "", "O", "X")
		contain = possible.include?(actual)
    assert_equal(true, contain)
  end

  def test_fork_move_3
		# @board=Board.new
    overall_status = [["X",2,3],[4,"O",6],[7,"X","O"],["X",4,7],[2,"O","X"],[3,6,"O"],["X","O","O"],[7,"O",3]]
    # @player1 = Player.new("Aaron", "X", @board)
    # @player2 = Computer.new("Computer", "O", @board)
		possible = [3,6]
		@level = Unbeatable.new
		actual = @level.fork_move(overall_status, "", "O", "X")
		contain = possible.include?(actual)
    assert_equal(true, contain)
  end


  def test_fork_block_1
    # @board=Board.new
    overall_status = [["O",2,3],[4,"X",6],[7,8,"X"],["O",4,7],[2,"X",8],[3,6,"X"],["O","X","X"],[7,"X",3]]
		board = ["O",2,3,4,"X",6,7,8,"X"]
		# @player1 = Player.new("Aaron", "X", @board)
    # @player2 = Computer.new("Computer", "O", @board)
		possible = [3,7]
		@level = Unbeatable.new
		actual = @level.fork_block(overall_status,board, "", "O", "X")
		contain = possible.include?(actual)
    assert_equal(true, contain)
  end

	def test_fork_block_2_with_only_one_fork_possibility
		  # @board=Board.new
		  overall_status = [["X",2,3],[4,"O","X"],[7,8,9],["X",4,7],[2,"O",8],[3,"X",9],["X","O",9],[7,"O",3]]
			board = ["X",2,3,4,"O","X",7,8,9]
			# @player1 = Player.new("Aaron", "X", @board)
		  # @player2 = Computer.new("Computer", "O", @board)
			@level = Unbeatable.new
			actual = @level.fork_block(overall_status,board, "", "O", "X")
		  assert_equal(3, actual)
	end

  def test_fork_block_3
    # @board=Board.new
    overall_status = [[1,2,"X"],[4,"O",6],["X",8,9],[1,4,"X"],[2,"O",8],["X",6,9],[1,"O",9],["X","O","X"]]
		board = [1,2,"X",4,"O",6,"X",8,9]
		# @player1 = Player.new("Aaron", "X", @board)
    # @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		possible = [2,4,6,8]
		actual = @level.fork_block(overall_status,board, "", "O", "X")
		contain = possible.include?(actual)
    assert_equal(true, contain)
  end

	def test_fork_block_4
		# @board=Board.new
		overall_status = [["X",2,3],[4,"X",6],[7,8,"O"],["X",4,7],[2,"X",8],[3,6,"O"],["X","X","O"],[7,"X",3]]
		board = ["X",2,3,4,"X",6,7,8,"O"]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		possible = [3,7]
		@level = Unbeatable.new
		actual = @level.fork_block(overall_status, board,"", "O", "X")
		# puts "actual from test is #{actual}"
		contain = possible.include?(actual)
		assert_equal(true, contain)
	end

	def test_fork_block_5
    # @board=Board.new
    overall_status = [[1,2,"O"],[4,"X",6],["X",8,9],[1,4,"X"],[2,"X",8],["O",6,9],[1,"X",9],["X","X","O"]]
		board = [1,2,"O",4,"X",6,"X",8,9]
		# @player1 = Player.new("Aaron", "X", @board)
    # @player2 = Computer.new("Computer", "O", @board)
		possible = [1,9]
		@level = Unbeatable.new
		actual = @level.fork_block(overall_status,board, "", "O", "X")
		contain = possible.include?(actual)
    assert_equal(true, contain)
  end

	def test_move_to_empty_corner
		# @board=Board.new
		state = ["O",2,3,4,"X",6,7,8,9]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.empty_corner(state, "")
		assert_equal(9, function)
	end

	def test_move_to_empty_corner_2
		# @board=Board.new
		state = [1,2,3,4,"X",6,7,8,"O"]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.empty_corner(state, "")
		assert_equal(7, function)
	end

  def test_opposite_corner_1
    # @board=Board.new
    state = ["X","X","O","O","O","X","X",8,9]
    # @player1 = Player.new("Aaron", "X", @board)
    # @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.play_opposite_corner(state, "", "O", "X")
    assert_equal(9, function)
  end

	def test_opposite_corner_2
    # @board=Board.new
    state = ["X","X",3,"X","O",6,"X","O","X"]
    # @player1 = Player.new("Aaron", "X", @board)
    # @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.play_opposite_corner(state, "", "O", "X")
    assert_equal(3, function)
  end

	def test_opposite_corner_3
		# @board=Board.new
		state = ["X",2,3,4,"O",6,7,8,9]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.play_opposite_corner(state, "", "O", "X")
		assert_equal(9, function)
	end

	def test_move_to_center_if_open_1
		# @board=Board.new
		state = ["X",2,3,4,5,6,7,8,9]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.play_center(state,"")
		assert_equal(5, function)
	end

	def test_move_to_center_if_open_2
		# @board=Board.new
		state = [1,2,3,4,5,6,7,"X",9]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.play_center(state,"")
		assert_equal(5, function)
	end

	def test_empty_edge
		# @board=Board.new
		state = ["X",2,"O","O","X","X","X","O","O"]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.empty_edge(state,"")
		assert_equal(2, function)
	end

	def test_two_in_a_row_1
		# @board=Board.new
		overall_status = [[1,2,"X"],["X","O",6],["O",8,9],[1,"X","O"],[2,"O",8],["X",6,9],[1,"O",9],["O","O","X"]]
		board_state = [1,2,"X","X","O",6,"O",8,9]
		# @player1 = Player.new("Aaron", "X", @board)
		# @player2 = Computer.new("Computer", "O", @board)
		@level = Unbeatable.new
		function = @level.create_two_in_a_row(overall_status, 10, "O", "X")
		assert_equal([8, 9, 2, 8, 1, 9], function)
	end

	def test_two_in_a_row_2
		# @board=Board.new
		overall_status = [["X",2,3],[4,"O","X"],[7,8,9],["X",4,7],[2,"O",8],[3,"X",9],["X","O",9],[7,"O",3]]
		board_state = ["X",2,3,4,"O","X",7,8,9]
		# @player1 = Human.new("Aaron", "X")
		# @player2 = Computer.new("Computer", "O", "X", 3)
		@level = Unbeatable.new
		function = @level.create_two_in_a_row(overall_status, 10, "O", "X")
		assert_equal([2, 8, 7, 3], function)
	end

	def test_sequential_level
		# @board=Board.new
		overall_status = [["O","O","X"],[4,"X",6],[7,"X",9],["O",4,7],["O","X","X"],[4,"X",6],[7,"X",9]]
		board_state = ["O","O","X",4,"X",6,7,"X",9]
		# @player1 = Human.new("Aaron", "X")
		# @player2 = Computer.new("Computer", "O", "X", 3)
		@level = Sequential.new
		function = @level.move(board_state,overall_status,"O", "X")
		assert_equal(4, function)
	end

	def test_sequential_level_2
		# @board=Board.new
		overall_status = [["O","O","X"],["O","X","X"],[7,"X",9],["O","O",7],["O","X","X"],["O","X","X"],[7,"X",9]]
		board_state = ["O","O","X","O","X","X",7,"X",9]
		# @player1 = Human.new("Aaron", "X")
		# @player2 = Computer.new("Computer", "O", "X", 3)
		@level = Sequential.new
		function = @level.move(board_state,overall_status,"O", "X")
		assert_equal(7, function)
	end

	def test_random_level_1
		# @board=Board.new
		overall_status = [["O","O","X"],["O","X","X"],[7,"X",9],["O","O",7],["O","X","X"],["O","X","X"],[7,"X",9]]
		board_state = ["O","O","X","O","X","X",7,"X",9]
		# @player1 = Human.new("Aaron", "X")
		# @player2 = Computer.new("Computer", "O", "X", 3)
		@level = Random.new
		possible = [7,9]
		actual = @level.move(board_state,overall_status,"O", "X")
		contain = possible.include?(actual)
		assert_equal(true, contain)
	end

	def test_random_level_2
		# @board=Board.new
		overall_status = [[1,2,"X"],["X","O",6],["O",8,9],[1,"X","O"],[2,"O",8],["X",6,9],[1,"O",9],["O","O","X"]]
		board_state = [1,2,"X","X","O",6,"O",8,9]
		# @player1 = Human.new("Aaron", "X")
		# @player2 = Computer.new("Computer", "O", "X", 3)
		@level = Random.new
		possible = [1,2,6,8,9]
		actual = @level.move(board_state,overall_status,"O", "X")
		contain = possible.include?(actual)
		assert_equal(true, contain)
	end

	def test_computer_VS_computer_unbeatable
		tie_count = 0
		win_count = 0
		for x in (1..1000) do
			game = Game.new("Computer1", "Computer2", 1, "player2", 3, 3)
			loop do
				cheese = game.current_player.move(game.board_state, game.overall_status)
				# puts "current player name is #{game.current_player.name}"
				# puts "CURRENT PLAYER IS #{game.current_player}"
				# puts "The turn is #{game.turn}"
				status = game.update_game_status(cheese)

				if status == "winner"
					win_count += 1
					break
				end

				if status == "tie"
					tie_count += 1
					break
				end
			end

		end
		puts "The results of the unbeatable test are:"
		puts "The number of ties were #{tie_count}"
		puts "The number of wins were #{win_count}"
	end

	def test_computer_VS_computer_random
		tie_count = 0
		win_count = 0
		for x in (1..1000) do
			game = Game.new("Computer1", "Computer2", 1, "player2", 1, 1)
			loop do
				cheese = game.current_player.move(game.board_state, game.overall_status)
				# puts "current player name is #{game.current_player.name}"
				# puts "CURRENT PLAYER IS #{game.current_player}"
				# puts "The turn is #{game.turn}"
				status = game.update_game_status(cheese)

				if status == "winner"
					win_count += 1
					break
				end

				if status == "tie"
					tie_count += 1
					break
				end
			end

		end
		puts "The results of the random test are:"
		puts "The number of ties were #{tie_count}"
		puts "The number of wins were #{win_count}"
	end

	def test_computer_VS_computer_random_VS_unbeatable
		tie_count = 0
		win_count = 0
		for x in (1..1000) do
			game = Game.new("Computer1", "Computer2", 1, "player2", 1, 3)
			loop do
				cheese = game.current_player.move(game.board_state, game.overall_status)
				# puts "current player name is #{game.current_player.name}"
				# puts "CURRENT PLAYER IS #{game.current_player}"
				# puts "The turn is #{game.turn}"
				status = game.update_game_status(cheese)

				if status == "winner"
					win_count += 1
					break
				end

				if status == "tie"
					tie_count += 1
					break
				end
			end

		end
		puts "The results of the random VS unbeatable test are:"
		puts "The number of ties were #{tie_count}"
		puts "The number of wins were #{win_count}"
	end
end
