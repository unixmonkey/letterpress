module LetterPress
  class Board
    %w(letters colors tiles words winners).each do |meth|
      attr_accessor meth.to_sym
    end

    def initialize(options={}, *args)
      self.letters = options[:letters] || ''
      self.colors  = options[:colors]  || ''
      self.tiles   = []
      start_random! unless letters.chars.any?
      position_tiles!
      set_colors!
      @words   = Hash.new{|hash,key| hash[key] = [] } # assign key to empty array if access fails
      @winners = []
    end

    %w(red pink lblue dblue white).each do |color|
      self.class_eval do
        define_method(color) do
          tiles.select{|t| t.color == color }
        end
      end
    end

    def grid
      out = ''
      column = 1
      tiles.each do |tile|
        out << "#{tile.colored}"
        if column == 5
          column = 1
          out << "\n"
        else
          column += 1
        end
      end
      out
    end

    def to_s
      red  = LetterPress::Tile.new(:color=>'red',   :letter=>red_points).colored
      blue = LetterPress::Tile.new(:color=>'dblue', :letter=>blue_points).colored
      "#{red} #{blue}\n\n#{grid}"
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
          if letter = pink.detect{|t| t.letter == c }
            letter.color = 'lblue'
          elsif letter = white.detect{|t| t.letter == c }
            letter.color = 'lblue'
          end
        end
      end
      find_and_color_solids!
      self
    end

    def find_and_color_solids! # blue team
      tiles.each do |tile|
        if tile.neighbors.values.compact.all?{|t| t.color == 'dblue' }
          tile.color = 'dblue'
        end
      end
    end

    def possible_moves
      compute_playable_words! if @words.empty?
      out = ''
      @words.sort_by{|w| "%02d" % w }.each do |score, words|
        out << "\n**** #{score} point words ****\n#{words.join(' ')}"
      end
      out
    end

    def winning_moves
      compute_playable_words! if @words.empty?
      out = "**** Winning moves: ****"
      if @winners.any?
        @words.each{|w| out << w }
      else
        out << "\nNo winning moves this turn :("
      end
      out
    end

    def moves_with_letters(str)
      compute_playable_words! if @words.empty?
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

    def tile_at(row, column)
      tiles.detect{|t| t.row == row && t.column == column }
    end

    def invert_colors!
      tiles.each{|t| t.invert_color! }
      self
    end


    private

    def start_random!
      alphabet = ('a'..'z').to_a
      25.times { self.letters << alphabet[rand(alphabet.size)] }
    end

    def position_tiles!
      self.tiles = []
      row = column = 1
      letters.chars.each do |char|
        self.tiles << LetterPress::Tile.new(
          :letter => char,
          :color  => 'white',
          :row    => row,
          :column => column,
          :board  => self
        )
        if column == 5
          column  = 1
          row    += 1
        else
          column += 1
        end
      end
      tiles
    end

    def set_colors!
      colored_tiles = []
      row = column = 1
      colors.chars.each do |color|
        t = tile_at(row, column)
        t.color = case color
          when 'r' then 'red'
          when 'p' then 'pink'
          when 'l' then 'lblue'
          when 'd' then 'dblue'
          else 'white'
        end
        colored_tiles << t
        if column == 5
          column  = 1
          row    += 1
        else
          column += 1
        end
      end
      tiles = colored_tiles
    end

    def compute_playable_words!
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