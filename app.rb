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
	erb :welcome
end


post '/play' do
	# session[:number_of_players] = params[:number_of_players]
	session[:player1_name] = params[:player1]
	session[:player2_name] = params[:player2]
	session[:difficulty] = params[:difficulty].to_i
	if session[:player2_name] == nil
		session[:player2_name] = "Computer"
	end
	redirect "/again"
end


# get '/game' do
# 	@@game = Game.new(session[:number_of_players], session[:player1_name], session[:player2_name], session[:difficulty])
# 	# session[:board_state] = @@game.board_state
# 	redirect "/again"
# 	# erb :board
# end


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


get "/again" do
	erb :again
end


post "/again" do
		@@game = Game.new(session[:player1_name], session[:player2_name], session[:difficulty], params[:first_move])
		# @@game.play_again(turn)
		# session[:board_state] = @@game.board_state
		redirect "move"
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
