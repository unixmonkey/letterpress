module LetterPress
  class Board
    %w(letters colors tiles dictionary).each do |meth|
      attr_accessor meth.to_sym
    end

    def initialize(options={}, *args)
      self.letters = options[:letters] || ''
      self.colors  = options[:colors]  || ''
      self.tiles   = []
      self.dictionary = options[:dictionary] ||
        LetterPress::Dictionary.new(:board => self)
      start_random! unless letters.chars.any?
      position_tiles!
      set_colors!
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

    def play!(word)
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
      invert_colors!
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
      dictionary.possible_moves
    end

    def winning_moves
      dictionary.winning_moves
    end

    def moves_with_letters(str)
      dictionary.moves_with_letters(str)
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

  end
end
