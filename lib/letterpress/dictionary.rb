module LetterPress
  class Dictionary

    %w(board source words winners played).each do |meth|
      attr_accessor meth.to_sym
    end

    def initialize(options)
      self.board  = options[:board]
      self.source = options[:source] || '/usr/share/dict/words'
      self.words  = Hash.new{|hash,key| hash[key] = [] } # assign key to empty array if access fails
      self.winners = []
      self.played  = []
    end

    def possible_moves
      compute_playable_words! if words.empty?
      out = ''
      words.sort_by{|w| "%02d" % w }.each do |score, words|
        out << "\n**** #{score} point words ****\n#{words.join(' ')}"
      end
      out
    end

    def winning_moves
      compute_playable_words! if words.empty? # must recompute every play :/
      out = "**** Winning moves: ****"
      if winners.any?
        words.each{|w| out << w }
      else
        out << "\nNo winning moves this turn :("
      end
      out
    end

    def moves_with_letters(str)
      compute_playable_words! if words.empty?
      out = "**** Words with letters: #{str} ****"
      hits = []
      words.each do |hash|
        hash.last.each do |word|
          if str && str.chars.all?{|c| word.include?(c) }
            hits << word
          end
        end
      end
      out << "\n#{hits.sort.join(' ')}"
    end

    def compute_playable_words!
      if source.is_a?(String)
        load_from_file
      else
        load_from_array
      end
    end

    def load_from_file
      File.open(source).each_line do |word|
        word = LetterPress::Word.new(word, board)
        if word.playable? && word.score > 0
          winners << word.to_s if word.winning?
          words[word.score] << word.to_s
        end
      end
    end

    def load_from_array
      source.each do |word|
        word = LetterPress::Word.new(word, board)
        if word.playable? && word.score > 0
          winners << word.to_s if word.winning?
          words[word.score] << word.to_s
        end
      end
    end

  end
end
