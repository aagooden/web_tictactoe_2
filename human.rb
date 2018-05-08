class Human
  @score
    attr_accessor :name, :piece

    def initialize(name, piece)

        @piece = piece
        @name = name
        @score = 0
    end

    def increase_score
        @score +=1
    end

    def score
        @score
    end

end
