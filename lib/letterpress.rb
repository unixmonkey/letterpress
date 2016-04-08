$LOAD_PATH.push File.expand_path('../../lib', __FILE__)
require 'letterpress/board'
require 'letterpress/word'
require 'letterpress/tile'
require 'letterpress/dictionary'

# program is being run interactively
if __FILE__ == $PROGRAM_NAME

  require 'getoptlong'
  opts = GetoptLong.new(
    ['--help',     '-h', GetoptLong::NO_ARGUMENT      ],
    ['--letters',  '-l', GetoptLong::REQUIRED_ARGUMENT],
    ['--colors',   '-c', GetoptLong::REQUIRED_ARGUMENT],
    ['--required', '-r', GetoptLong::OPTIONAL_ARGUMENT]
  )
  help = letters = colors = required = nil
  opts.each do |opt, arg|
    case opt
      when '--help'
        help = true
      when '--letters'
        letters = arg.to_s
      when '--colors'
        colors = arg.to_s
      when '--required'
        required = arg.to_s
    end
  end

  if help
    puts "letterpress.rb",
         "Usage:",
         "  ruby letterpress.rb [options]\n",
         "Options:",
         "  --help,     -h (shows this usage message)",
         "  --letters,  -l [letters on the board starting from the top-right corner]",
         "  --colors,   -l [colors on the board: r=red, p=pink, l=lightblue, d=darkblue, w=white]",
         "  --require,  -r [letters required in the hint results]",
         "Examples:",
         "  # setup board from input and provide suggestions for possible moves",
         "  ruby letterpress.rb --letters lbbbesauxnovrpyfcomrvxrwz --colors rrrplrppldpllllpppppwwplw",
         "",
         "  # start a new game from scratch and play against the computer",
         "  ruby letterpress.rb"
    exit
  end

  board = LetterPress::Board.new(
    letters: letters,
    colors: colors
  )
  puts board
  puts

  if letters
    puts board.possible_moves
    puts
    puts board.winning_moves
  else
    puts 'Loading dictionary...please wait:'
    board.dictionary.compute_playable_words!
    words = board.dictionary.words
    while true
      # until winning move is played
      puts 'Play a word: '
      pword = gets
      if board.play!(pword) # player play
        puts "Player plays: #{pword}"
        puts board
        points_to_play = words.keys[rand(words.keys.size)]
        word = words[points_to_play][rand(words[points_to_play].size)]
        puts 'thinking.'
        5.times do
          sleep 0.5
          print '.'
        end
        puts "Computer plays: #{word} for #{points_to_play} points"

        board.play!(word) # computer play
        puts board
      else
        puts "#{pword} is not a playable word."
      end
    end
  end

  if required
    puts "\n"
    puts board.show_moves_with_letters(required)
  end

end
