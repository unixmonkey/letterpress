require File.expand_path("../test_helper.rb", __FILE__)

class TestTile < Test::Unit::TestCase

  def test_to_s
    tile = LetterPress::Tile.new(:letter => 't')
    assert_equal('t', tile.to_s)
  end

  def test_colored
    tile = LetterPress::Tile.new(:color => 'red', :letter => 'r')
    assert_equal("\e[41m r \e[0m", tile.colored)
  end

  def test_position
    tile = LetterPress::Tile.new(:row => 1, :column => 3)
    assert_equal([1,3], tile.position)
  end

  def test_neighbors
    board = LetterPress::Board.new(
      :letters => 'lbbbesauxnovrpyfcomrvxrwz',
      :colors  => 'rrrplrppldpllllpppppwwplw'
    )
    tile = board.tile_at(2,4)
    assert_equal('x', tile.letter)
    expected = { :n=>'b',:ne=>'e',:e=>'n',:se=>'y',:s=>'p',:sw=>'r',:w=>'u',:nw=>'b' }
    expected.each do |k,v|
      assert_equal(v, tile.neighbors[k].letter)
    end
  end

  def test_invert_color
    tile = LetterPress::Tile.new(:color => 'pink')
    tile.invert_color!
    assert_equal('lblue', tile.color)
  end

end
