require "sinatra"
require "erb"
require_relative "tictactoe_methods.rb"

enable :sessions


get "/" do
	erb :welcome
end


post '/play' do
	session[:number_of_players] = params[:number_of_players]
	session[:player1] = params[:player1]
	session[:player2] = params[:player2]
	session[:difficulty] = params[:difficulty]
	redirect "/game"
end


get '/game' do
	session[:game] = Game.new(session[:number_of_players], session[:player1], session[:player2], session[:difficulty])
	session[:board_state] = session[:game].board_state
	redirect "/again"
	# erb :board
end


get '/move' do
	current_move = params[:move]

	#Step 1: Check to see if current_move has already been played...if so, redirect back to board for another try
	if session[:game].board_state.include?(current_move.to_i) == false
		redirect "/no_dice"
	end

	 #Step 2: check to see who played the move (player1 or player2) and route accordingly
	if session[:game].turn == true #player1
		session[:game_status] = session[:game].play(current_move)
	elsif session[:game].turn == false && session[:game].player2_class == Player #player2 is human
	 	session[:game_status] = session[:game].play(current_move)
	 end
	 # Check for winner or tie
	if session[:game_status][5] == "winner" || session[:game_status][5] == "tie"
		redirect "/winner"
	end

	#if the current player is computer, the move must be determined by sending to session[:game].play
  if session[:game].turn == false && session[:game].player2_class == Computer #player2 is human
	 session[:game_status] = session[:game].play(10) #10 is a placeholder...this move is not actually used in calculating computer's move

	 #if computer's move results in win or tie redirect to winner route
	 	if session[:game_status][5] == "winner" || session[:game_status][5] == "tie"
 			redirect "/winner"
 		end
	end

	session[:board_state] = session[:game].board_state

	redirect "/board" #render board to show moves and get next move
end


get "/no_dice" do
	redirect "/board"
end


get "/winner" do
	session[:winner] = session[:game_status][0]
	session[:player1_name] = session[:game_status][1]
	session[:player1_score] = session[:game_status][2]
	session[:player2_name] = session[:game_status][3]
	session[:player2_score] = session[:game_status][4]
	session[:win_tie] = session[:game_status][5]

	if session[:win_tie] == "winner"
		session[:message1] = "Way to go #{session[:winner]}, YOU WIN!!"
	else
		session[:message1] = "Better luck next time...IT'S A TIE!"
	end

	# creates an array of images to use in constructing the board
	images = []
	session[:board_state].each do |position|
	if position.is_a?Integer
	  images.push("blank.jpg")
	elsif position == "X"
	  images.push("x.png")
	elsif position == "O"
	  images.push("o.png")
	end
	end
	session[:images] = images
	erb :winner
end


get "/again" do
	if session[:number_of_players] == "1"
		session[:player2] = "Computer"
	end
	erb :again
end


post "/again" do
	first_move = params[:first_move]

	# Check that player2 is the Computer AND player2 is supposed to go first in the next game
	if session[:game].player2_class == Computer && first_move == "player2"
		session[:game].play_again(false)
		session[:board_state] = session[:game].board_state
		session[:game].play(10) #10 is just a placeholder for calling session[:game].play on the computer's turn
		redirect "/board"
	else
		if first_move == "player2"
			turn = false
		else
			turn = true
		end
		session[:game].play_again(turn)
		session[:board_state] = session[:game].board_state
		redirect "/board"
	end

end

get "/board" do
	# creates an array of images to use in constructing the board
	images = []
	session[:board_state].each do |position|
	if position.is_a?Integer
		images.push("blank.jpg")
	elsif position == "X"
		images.push("x.png")
	elsif position == "O"
		images.push("o.png")
	end
	end
	session[:images] = images
	erb :board
end
