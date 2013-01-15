$:.push File.expand_path("../../lib", __FILE__)
require 'test/unit'
require 'letterpress'

class TestBoard < Test::Unit::TestCase

  def setup
    @options = {
      :letters => 'lbbbesauxnovrpyfcomrvxrwz',
      :colors  => 'rrrplrppldpllllpppppwwplw'
    }
  end

  def test_new_without_args_sets_up_an_all_white_board_and_score_of_zero
    board = LetterPress::Board.new()
    assert_equal(0,  board.red_points,          'Red points are 0')
    assert_equal(0,  board.blue_points,         'Blue points are 0')
    assert_equal(25, board.letters.chars.count, 'There are 25 tiles on the board')
    assert_equal(25, board.white.count,         'All tiles are white')
  end

  def test_new_with_args_sets_up_the_board_with_tiles_given
    board = LetterPress::Board.new(@options)
    assert_equal(14, board.red_points)
    assert_equal(8,  board.blue_points)
    assert_equal(4,  board.red.count)
    assert_equal(10, board.pink.count)
    assert_equal(7,  board.lblue.count)
    assert_equal(1,  board.dblue.count)
    assert_equal(3,  board.white.count)
  end

  def test_to_s_shows_board_state
    board = LetterPress::Board.new()
    assert(board.to_s)
  end

  def test_play_recauculates_score_and_changes_tile_colors
    board = LetterPress::Board.new(@options)
    board.play!("clamber")
    assert_equal(9,  board.red_points)
    assert_equal(13, board.blue_points)
  end

  def test_possible_moves
    board = LetterPress::Board.new(@options)
    board.words[4] << "clamber" # preload dictionary
    moves = board.possible_moves
    assert_match(moves, /point words/)
    assert_match(moves, /clamber/)
  end

  def test_winning_moves_with_no_winning_moves
    board = LetterPress::Board.new(@options)
    board.words[4] << "clamber" # preload dictionary
    moves = board.winning_moves
    assert_match(moves, /Winning moves/)
    assert_match(moves, /No winning moves/)
  end

  def test_moves_with_letters
    board = LetterPress::Board.new(@options)
    board.words[4] << "clamber" # preload dictionary
    board.words[4] << "comb"
    moves = board.moves_with_letters('rmb')
    assert_match(/Words with letters/, moves)
    assert_match(/clamber/, moves)
    assert_no_match(/comb/, moves)
  end

end