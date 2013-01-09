module LetterPress
  class Word # may be better as class Play or Move
    %w(red pink blue white).each do |color|
      attr_accessor color.to_sym
    end

    def initialize(word, board)
      @word  = word.chomp
      @board = board

      # copies to pick letters away from
      @red   = board.red
      @pink  = board.pink
      @blue  = board.blue
      @white = board.white

      # starting scores from the board
      @red_score  = board.red_points
      @blue_score = board.blue_points
    end

    def to_s
      @word
    end

    def playable?
      !@word.each_char.map do |c|
        @board.letters.include?(c) &&                      # word contains all given letters
        (@word.scan(c).size <= @board.letters.scan(c).size) # there are no more instances of a letter than counted in @board.letters
      end.include?(false)
    end

    def winning?
      @white.empty? &&           # must use all white tiles
      (@blue_score > @red_score) # and have a winning score
    end

    def compute_score!
      @word.chars.each do |c|
        if @pink.include?(c)
          @pink = @pink.sub(c,'') # remove from available tiles
          @red_score  -= 1
          @blue_score += 1
        elsif @white.include?(c)
          @white = @white.sub(c,'')
          @blue_score += 1
        elsif @red.include?(c)
          @red = @red.sub(c,'')
        elsif @blue.include?(c)
          @blue = @blue.sub(c,'')
        end
      end
    end

    def score
      compute_score!
      (@blue_score - @red_score)
    end

  end
end