class Board

    def initialize(state=[1,2,3,4,5,6,7,8,9])
        @state = state
    end

		def state
			@state
		end

    def reset
      @state = [1,2,3,4,5,6,7,8,9]
    end

    def overall_status
      overall_status = []
      combos = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]]
        combos.each do |group|
          temp = []
            group.each do |position|
              temp.push(@state[position])
            end
            overall_status.push(temp)
        end
        return overall_status
    end

    def change_state(piece, position)
        @state[position-1] = piece
    end

    def check_position(position)
        if @state[position -1] == "X" || @state[position -1] == "O"
            false
        else
            true
        end
    end

    def check_tie
        @state.all? {|i| i.is_a?(String) }
    end

    def check_winner
      winner = false
      overall_status().each do |group|
        if group.count("X") == 3 || group.count("O") == 3
            winner = true
        end
      end
      return winner
    end

end
