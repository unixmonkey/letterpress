require 'gosu'

$:.push File.expand_path("../../lib", __FILE__)
require 'letterpress/board'
require 'letterpress/word'
require 'letterpress/tile'
require 'letterpress/dictionary'

class GameWindow < Gosu::Window

  def initialize
    @width  = 250
    @height = 350
    @tsize  = 50
    super(@width, @height, false)

    self.caption = 'LetterPress'
    @white = Gosu::Color::WHITE
    @bg    = @white
    @board = LetterPress::Board.new(
      :letters => 'lbbbesauxnovrpyfcomrvxrwz',
      :colors => 'rrrplrppldpllllpppppwwplw')
    @font = Gosu::Font.new(self, Gosu::default_font_name, 35)
  end

  def update
  end

  def draw
    draw_background
    draw_score
    @board.tiles.each do |tile|
      y_pos = (tile.row-1)*@tsize + (@tsize*2)
      x_pos = (tile.column-1)*@tsize
      draw_tile(x_pos, y_pos, color(tile.color))
      @font.draw_rel(tile.letter.upcase, (x_pos+(@tsize/2)), (y_pos+(@tsize/2)), 1, 0.5, 0.5, 1.0, 1.0, Gosu::Color::BLACK)
    end
  end

  private

  def color(c)
    case c
      when 'red' then Gosu::Color::RED
      when 'pink' then Gosu::Color::FUCHSIA
      when 'lblue' then Gosu::Color::AQUA
      when 'dblue' then Gosu::Color::BLUE
      else Gosu::Color::WHITE
    end
  end

  def draw_score
    draw_tile( (@tsize*1.25), (@tsize/2), color('red') )
    @font.draw_rel(@board.red_points, ((@tsize/1.25)+25), ((@tsize/2)+25), 1, 0.5, 0.5, 1.0, 1.0, Gosu::Color::BLACK)
    draw_tile( (@tsize*2.75), (@tsize/2), color('dblue') )
    @font.draw_rel(@board.blue_points, ((@tsize/2.75)+25), ((@tsize/2)+25), 1, 0.5, 0.5, 1.0, 1.0, Gosu::Color::BLACK)
  end

  def draw_background
    draw_quad(0,      0,      @bg,
              @width, 0,      @bg,
              0,      @height, @bg,
              @width, @height, @bg,
              0)
  end

  def draw_tile(x, y, color)
    draw_quad(x,          y,          color,
              (x+@tsize), y,          color,
              x,          (y+@tsize), color,
              (x+@tsize), (y+@tsize), color, 1)
  end

end

window = GameWindow.new
window.show
