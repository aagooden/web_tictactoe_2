require "sinatra"
require "erb"
require_relative "game.rb"
require_relative "human.rb"
require_relative "computer.rb"
require_relative "board.rb"
require_relative "random.rb"
require_relative "sequential.rb"
require_relative "unbeatable.rb"

enable :sessions



get "/" do
	erb :setup
end

post "/welcome" do
	if params[:game_type] == "computer"
		erb :difficulty
	else
		erb :welcome
	end
end

post '/computer_play' do
	# session[:number_of_players] = params[:number_of_players]
	session[:player1_name] = "Computer1"
	session[:player2_name] = "Computer2"
	session[:computer1_level] = params[:difficulty_selection1].to_i
	session[:computer2_level] = params[:difficulty_selection2].to_i
	redirect "/new_computer_game"
end


post '/play' do
	# session[:number_of_players] = params[:number_of_players]
	session[:player1_name] = params[:player1]
	session[:player2_name] = params[:player2]
	session[:difficulty] = params[:difficulty].to_i
	if session[:player2_name] == nil
		session[:player2_name] = "Computer"
	end
	redirect "/new_game"
end


get '/move' do
	# session[:current_move] = params[:move]
	if @@game.current_player.class == Computer
		session[:move] = @@game.current_player.move(@@game.board_state, @@game.overall_status)
		redirect "/update_game_status"
	else
		redirect "/board"
	end
end


get '/update_game_status' do
	if @@game.current_player.class == Computer
		session[:game_status] = @@game.update_game_status(session[:move])
	else
	session[:game_status] = @@game.update_game_status(params[:move].to_i)
	end

	case session[:game_status]
	when "winner"
		redirect "/winner"
	when "tie"
		redirect "/winner"
	when "no_dice"
		redirect "/no_dice"
	else
		redirect "/move"
	end

end


get "/no_dice" do
	redirect "/board"
end


get "/winner" do
	if session[:game_status] == "winner"
		session[:message1] = "Way to go #{@@game.current_player.name}, YOU WIN!!"
	else
		session[:message1] = "Better luck next time...IT'S A TIE!"
	end

	# creates an array of images to use in constructing the board
	images = []
	@@game.board_state.each do |position|
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

get "/new_game" do
	erb :new_game
end

post "/new_game" do
		if session[:player1_name] == "Computer1"
			erb :difficulty
		else
			@@game = Game.new(session[:player1_name], session[:player2_name], session[:difficulty], params[:first_move], "placeholder", "placeholder")
			# @@game.play_again(turn)
			# session[:board_state] = @@game.board_state
			redirect "move"
		end
end


get "/again" do
	erb :again
end


post "/again" do
		session[:first_move] = params[:first_move]
		if session[:player1_name] == "Computer1"
			@@game.play_again(session[:first_move])
			redirect "move"
		else
			# @@game = Game.new(session[:player1_name], session[:player2_name], session[:difficulty], params[:first_move], "placeholder", "placeholder")
			@@game.play_again(session[:first_move])
			redirect "move"
		end
end

get "/board" do
	# creates an array of images to use in constructing the board
	images = []
	@@game.board_state.each do |position|
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

get "/new_computer_game" do
	@@game = Game.new(session[:player1_name], session[:player2_name], session[:difficulty], "player1", session[:computer1_level], session[:computer2_level])

	redirect "move"
end
