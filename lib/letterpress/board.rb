module LetterPress
  class Board
    %w(red pink blue white).each do |color|
      attr_accessor color.to_sym
    end

    def initialize(*args)
      @red, @pink, @blue, @white = args
      @words = Hash.new{|hash,key| hash[key] = [] } # assign key to empty array if access fails
      @winners = []
    end

    def to_s
      "Letters:\n"+
        %w(red pink blue white).inject(''){|a,color| a << "#{color}(#{self.send(color)}) " } +
        "\nScore: red(#{red_points}) blue(#{blue_points})"
    end

    def letters
      red + pink + blue + white
    end

    def red_points
      red.size + pink.size
    end

    def blue_points
      blue.size
    end

    def play!(word) # blue team
      word = LetterPress::Word.new(word, self)
      word.compute_score!
      if word.playable?
        word.to_s.chars.each do |c|
          if pink.include?(c)
            @pink = @pink.sub(c,'') # pink turns blue
            @blue = @blue + c
          elsif white.include?(c)
            @white = @white.sub(c,'') # white turns blue
            @blue = @blue + c
          end
        end
      end
      self
    end

    def show_possible_moves
      compute_playable_words if @words.empty?
      @words.sort_by{|w| "%02d" % w }.each do |score, words|
        puts "\n**** #{score} point words ****", words.join(' ')
      end
    end

    def show_winning_moves
      compute_playable_words if @words.empty?
      puts "**** Winning moves: ****"
      if @winners.any?
        @words.each{|w| puts w }
      else
        puts "No winning moves this turn :("
      end
    end

    def show_moves_with_letters(str)
      compute_playable_words if @words.empty?
      puts "**** Words with letters: #{str} ****"
      hits = []
      @words.each do |hash|
        hash.last.each do |word|
          if str && str.chars.all?{|c| word.include?(c) }
            hits << word
          end
        end
      end
      puts hits.sort.join(' ')
    end

    private

    def compute_playable_words
      File.open("/usr/share/dict/words").each_line do |word|
        word = LetterPress::Word.new(word, self)
        if word.playable? && word.score > 0
          @winners << word.to_s if word.winning?
          @words[word.score] << word.to_s
        end
      end
    end

  end
end