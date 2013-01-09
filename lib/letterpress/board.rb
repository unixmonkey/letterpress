module LetterPress
  class Board
    %w(red pink lblue dblue blue white words winners).each do |meth|
      attr_accessor meth.to_sym
    end

    def initialize(options={}, *args)
      self.red   = options[:red]   || ''
      self.pink  = options[:pink]  || ''
      self.lblue = options[:lblue] || ''
      self.dblue = options[:dblue] || ''
      self.white = options[:white] || ''
      start_random unless options.any?
      @words   = Hash.new{|hash,key| hash[key] = [] } # assign key to empty array if access fails
      @winners = []
    end

    def start_random
      alphabet = ('a'..'z').to_a
      25.times { self.white << alphabet[rand(alphabet.size)] }
    end

    def to_s
      "Letters:\n"+
        %w(red pink lblue dblue white).inject(''){|a,color| a << "#{color}(#{self.send(color)}) " } +
        "\nScore: red(#{red_points}) blue(#{blue_points})"
    end

    def letters
      red + pink + lblue + dblue + white
    end

    def red_points
      red.size + pink.size
    end

    def blue_points
      lblue.size + dblue.size
    end

    def play!(word) # blue team
      word = LetterPress::Word.new(word, self)
      word.compute_score!
      if word.playable?
        word.to_s.chars.each do |c|
          if pink.include?(c)
            @pink = @pink.sub(c,'') # pink turns lblue
            @lblue = @lblue + c
          elsif white.include?(c)
            @white = @white.sub(c,'') # white turns lblue
            @lblue = @lblue + c
          end
        end
      end
      self
    end

    def possible_moves
      compute_playable_words if @words.empty?
      out = ''
      @words.sort_by{|w| "%02d" % w }.each do |score, words|
        out << "\n**** #{score} point words ****\n#{words.join(' ')}"
      end
      out
    end

    def winning_moves
      compute_playable_words if @words.empty?
      out = "**** Winning moves: ****"
      if @winners.any?
        @words.each{|w| out << w }
      else
        out << "No winning moves this turn :("
      end
      out
    end

    def moves_with_letters(str)
      compute_playable_words if @words.empty?
      out = "**** Words with letters: #{str} ****"
      hits = []
      @words.each do |hash|
        hash.last.each do |word|
          if str && str.chars.all?{|c| word.include?(c) }
            hits << word
          end
        end
      end
      out << "\n#{hits.sort.join(' ')}"
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