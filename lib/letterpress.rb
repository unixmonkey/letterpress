$:.push File.expand_path("../../lib", __FILE__)
require 'letterpress/board'
require 'letterpress/word'
require 'letterpress/tile'

# program is being run interactively
if __FILE__ == $PROGRAM_NAME

  unless ARGV && ARGV.size >= 2
    puts "Usage: letterpress.rb letters=lbbbesauxnovrpyfcomrvxrwz colors=rrrplrppldpllllpppppwwplw [require=dp]"
    exit
  end

  board = LetterPress::Board.new(
    :letters => ARGV[0].gsub('letters=',''),
    :colors  => ARGV[1].gsub('colors=','')
  )
  puts board
  puts
  puts board.possible_moves
  puts
  puts board.winning_moves

  if ARGV[2]
    puts "\n"
    board.show_moves_with_letters(ARGV[2].gsub('require=',''))
  end

end