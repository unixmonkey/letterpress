$:.push File.expand_path("../../lib", __FILE__)
require 'letterpress/board'
require 'letterpress/word'

# program is being run interactively
if __FILE__ == $PROGRAM_NAME

  unless ARGV && ARGV.size >= 5
    puts "Usage: letterpress.rb red=lbbs pink=bauofcomrr lblue=exvrpyw dblue=n white=vxz [require=dp]"
    exit
  end

  board = LetterPress::Board.new(
    :red    => ARGV[0].gsub('red=',''),
    :pink   => ARGV[1].gsub('pink=',''),
    :lblue  => ARGV[2].gsub('lblue=',''),
    :dblue  => ARGV[3].gsub('dblue=',''),
    :white  => ARGV[4].gsub('white=','')
  )
  puts board.possible_moves
  puts "\n"
  board.winning_moves

  if ARGV[5]
    puts "\n"
    board.show_moves_with_letters(ARGV[5].gsub('require=',''))
  end

end