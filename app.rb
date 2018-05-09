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
	session.clear
	erb :setup
end

post "/welcome" do
	if params[:game_type] == "computer"
		erb :difficulty
	else
		erb :welcome
	end
end

post '/play' do
	# session[:number_of_players] = params[:number_of_players]
	player1_name = params[:player1]
	player2_name = params[:player2]
	difficulty = params[:difficulty]
	if player2_name == nil
		player2_name = "Computer"
	end
	redirect "/new_game?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty
end

get "/new_game" do
	player1_name = params[:player1_name]
	player2_name = params[:player2_name]
	difficulty = params[:difficulty]
	erb :new_game, locals: {player1_name: player1_name, player2_name: player2_name, difficulty: difficulty}
end

post "/new_game" do
	first_move = params[:first_move]
	player1_name = params[:player1_name]
	player2_name = params[:player2_name]
	difficulty = params[:difficulty]
		if player1_name == "Computer1"
			erb :difficulty
		else
			session[:game] = Game.new(player1_name, player2_name, difficulty.to_i, first_move, "placeholder", "placeholder")
			puts "$$$$$$$$$$$$$$$ session[:game].current_player.name = #{session[:game].current_player.name}"
			redirect "/move?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty + "&first_move=" + first_move
		end
end

post '/computer_play' do
	# session[:number_of_players] = params[:number_of_players]
	player1_name = "Computer1"
	player2_name = "Computer2"
	computer1_level = params[:difficulty_selection1]
	computer2_level = params[:difficulty_selection2]
	redirect "/new_computer_game?player1_name=" + player1_name + "&player2_name=" + player2_name + "&computer1_level=" + computer1_level + "&computer2_level=" + computer2_level
end

get "/new_computer_game" do
	player1_name = params[:player1_name]
	player2_name = params[:player2_name]
	computer1_level = params[:computer1_level]
	computer2_level = params[:computer2_level]
	difficulty = "placeholder"
	first_move = "placeholder"
	session[:game] = Game.new(player1_name, player2_name, difficulty, first_move, computer1_level, computer2_level)

	redirect "/move?player1_name=" + player1_name + "&player2_name=" + player2_name + "&computer1_level=" + computer1_level + "&computer2_level=" + computer2_level + "&difficulty=" + difficulty
end


get '/move' do
	player1_name = params[:player1_name]
	player2_name = params[:player2_name]
	difficulty = params[:difficulty]
	# session[:current_move] = params[:move]
	if session[:game].current_player.name == "Computer1" || session[:game].current_player.name == "Computer2"
		loop do
			level = [Random.new, Sequential.new, Unbeatable.new][session[:game].current_player.level.to_i - 1]
			# current_move = session[:game].current_player.move(session[:game].board_state, session[:game].overall_status)
			current_move = level.move(session[:game].board_state, session[:game].overall_status, session[:game].current_player.piece, session[:game].current_player.opponent_piece)

			game_status = session[:game].update_game_status(current_move)

			case game_status
			when "winner"
				redirect "/winner?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty + "&game_status=" + game_status
			when "tie"
				redirect "/winner?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty + "&game_status=" + game_status
			when "no_dice"
				redirect "/no_dice?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty + "&game_status=" + game_status
			else
			end
		end

	elsif session[:game].current_player.class == Computer
		level = [Random.new, Sequential.new, Unbeatable.new][difficulty.to_i - 1]
		# current_move = session[:game].current_player.move(session[:game].board_state, session[:game].overall_status)
		current_move = level.move(session[:game].board_state, session[:game].overall_status, session[:game].current_player.piece, session[:game].current_player.opponent_piece)
		redirect "/update_game_status?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty + "&current_move=" + current_move.to_s

	else
		redirect "/board?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty
	end

end


get '/update_game_status' do
	player1_name = params[:player1_name]
	player2_name = params[:player2_name]
	difficulty = params[:difficulty]
	current_move = params[:current_move]
	# first_move = params[:first_move]
	if session[:game].current_player.class == Computer
		game_status = session[:game].update_game_status(current_move.to_i)
	else
		game_status = session[:game].update_game_status(params[:current_move].to_i)
	end

	case game_status
	when "winner"
		redirect "/winner?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty  + "&game_status=" + game_status
	when "tie"
		redirect "/winner?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty + "&game_status=" + game_status
	when "no_dice"
		redirect "/no_dice?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty + "&game_status=" + game_status
	else
		redirect "/move?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty + "&game_status=" + game_status
	end

end


get "/no_dice" do
	redirect "/board"
end


get "/winner" do
	player1_name = params[:player1_name]
	player2_name = params[:player2_name]
	difficulty = params[:difficulty]
	game_status = params[:game_status]
	if game_status == "winner"
		session[:message1] = "Way to go #{session[:game].current_player.name}, YOU WIN!!"
	else
		session[:message1] = "Better luck next time...IT'S A TIE!"
	end
	erb :winner, locals: {player1_name: player1_name, player2_name: player2_name, difficulty: difficulty, game_status: game_status }
end


get "/again" do
	player1_name = params[:player1_name]
	player2_name = params[:player2_name]
	erb :again, locals: {player1_name: player1_name, player2_name: player2_name}
end


post "/again" do
		first_move = params[:first_move]
		player1_name = params[:player1_name]
		player2_name = params[:player2_name]
		if player2_name == "Computer2" 
			difficulty = session[:game].player2.level.to_s
		elsif player2_name == "Computer"
				difficulty = session[:game].player2.level.to_s
		else
			difficulty = "placeholder"
		end
			session[:game].play_again(first_move)
			redirect "/move?player1_name=" + player1_name + "&player2_name=" + player2_name + "&difficulty=" + difficulty + "&first_move=" + first_move		# else
end

get "/board" do
	player1_name = params[:player1_name]
	player2_name = params[:player2_name]
	difficulty = params[:difficulty]

	erb :board, locals: {player1_name: player1_name, player2_name: player2_name, difficulty: difficulty}
end
