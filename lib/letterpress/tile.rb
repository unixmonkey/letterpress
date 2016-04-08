module LetterPress
  class Tile
    %w(letter color row column board).each do |meth|
      attr_accessor meth.to_sym
    end

    def initialize(options = {})
      self.letter = options[:letter]
      self.color  = options[:color]
      self.row    = options[:row]
      self.column = options[:column]
      self.board  = options[:board]
    end

    def to_s
      letter
    end

    def colored
      "\e[#{color_code}m #{letter} \e[0m"
    end

    def position
      [row, column]
    end

    def neighbors
      {
        n:  board.tile_at((row - 1), column),
        ne: board.tile_at((row - 1), (column + 1)),
        e:  board.tile_at(row, (column + 1)),
        se: board.tile_at((row + 1), (column + 1)),
        s:  board.tile_at((row + 1), column),
        sw: board.tile_at((row + 1), (column - 1)),
        w:  board.tile_at(row, (column - 1)),
        nw: board.tile_at((row - 1), (column - 1))
      }
    end

    def invert_color!
      self.color = case color
        when 'red' then 'dblue'
        when 'pink' then 'lblue'
        when 'dblue' then 'red'
        when 'lblue' then 'pink'
        else 'white'
      end
    end

    private

    def color_code
      case color.to_s
        when 'red'   then 41
        when 'pink'  then 45
        when 'lblue' then 46
        when 'dblue' then 44
        else 7
      end
    end
  end
end
