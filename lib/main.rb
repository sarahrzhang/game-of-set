require_relative './cards'
require_relative './deck'
require_relative './game'
require_relative './players'
require 'colorize'
require 'lolize'

# constants for min and max numbers of players
MIN_PLAYERS = 1
MAX_PLAYERS = 12

# create colorizer to print rainbow text
colorizer = Lolize::Colorizer.new

# print rules of game
colorizer.write "Welcome to the Game of Set!\n
These are rules of the game:\n
There can be 1 to 12 players.\n
Identify a set of 3 cards from 12 cards chosen randomly from a deck of 81 cards.\n
A Set consists of three cards in which each attribute is either the same on each
card or is different on each card.\n
Each card has four attributes:
Shapes - ovals, squiggles, or diamonds
Colors - red, blue, or green
Number - one, two, or three
Shading - solid, striped, or blank\n
Each player will pick a lowercase letter from the keyboard that will be used as a key 
to identify them. Player numbers are also assigned a player number that corresponds 
with the order in which they are assigned keys. When players want to find a set, they  
must buzz in by first entering their key. Any characters may be used as keys, except  
for 'q', 'c', 'a', and 'h'. These keys are designated for other functionalities. ' 
q' is used to quit the game, 'c' is for cheating by allowing the program to find sets 
for you, 'a' will add three cards to the board if there is not already a set present, 
and 'h' will display a hint.\n\n"

# get number of players with unbuffered IO
num_players = 0
puts 'How many players would like to play the game?'
while num_players < MIN_PLAYERS || num_players > MAX_PLAYERS
  num_players = gets.chomp.to_i
  if num_players < MIN_PLAYERS || num_players > MAX_PLAYERS
    # any key input except a positive int will set numPlayers to 0
    puts 'Error, please enter a valid number of players.'
  end

end

# make a keyArray and a playerArray
key_array = Array.new(num_players + 4) #=> [nil, nil, ..., nil]
players_array = Array.new(num_players + 1) #=> [nil, nil, ..., nil]
# create key for quitting the game
key_array[0] = 'q'
# add an extra key to be able to press hint, cheat and add cards
key_array[num_players + 1] = 'h'
key_array[num_players + 2] = 'c'
key_array[num_players + 3] = 'a'
players_array[0] = Player.new(0, 'q')

# loop until valid key assignments have been made for each player
(1..num_players).each do |i|
  char_assigned = 'q'
  while (key_array.include? char_assigned) || !Player.lowercase_char(char_assigned)
    puts "\nAssign a key to Player #{i}:"
    system('stty raw -echo') #=> Raw mode, no echo
    char_assigned = $stdin.getc
    system('stty -raw echo') #=> Reset terminal mode
  end
  key_array[i] = char_assigned
  # create a player for each key
  players_array[i] = Player.new(i, char_assigned)
  puts "Player #{i} has been assigned key #{char_assigned}."
end

# print starting message
colorizer.write "\nLet the game begin!\n\n"
# keep track of the duration of the game
start_time = Time.now

# create the deck and shuffle
deck = Deck.new
deck.shuffle_deck
deck.draw_twelve

# begin playing the game
until Game.game_over(deck)
  # display initial board
  deck.display_board

  # players buzz in when they see a set
  puts "\nType your assigned character if you see a set!"
  system('stty raw -echo') #=> Raw mode, no echo
  key_pressed = nil
  until key_array.include? key_pressed
    # wait for a key to be pressed
    # puts "we are in the inner while"
    key_pressed = $stdin.getc
  end
  system('stty -raw echo') #=> Reset terminal mode

  # switch case to check for quit, cheat, hint, add cards
  case key_pressed
  when 'a'
    # only lets players add 3 additional cards if no sets are displayed on board
    if !Game.find_set(deck, false, false)
      puts "\nAdded 3 additional cards to the board.".white.on_blue
      puts
      deck.add_three_cards
    else 
      puts "\nUnable to add 3 cards because there is at least one set on the board.".white.on_blue
      puts
    end
    next
  when 'c'
    # cheat boolean is true, hint false
    Game.find_set(deck, true, false)
    next
  when 'h'
    # hint function auto show. cheat boolean false
    Game.find_set(deck, false, true)
    next
  when 'q'
    # quit the game
    break
  end

  puts "\nPlayer #{key_array.index(key_pressed)} has buzzed in! Hurry up and make a set!\n".red.on_yellow
  # perform a turn corresponding to the keyPressed
  t1 = Time.now
  # put any turn action in here where sleep is.
  players_array[key_array.index(key_pressed)].player_turn(deck)

  turn_time = Time.now - t1
  players_array[key_array.index(key_pressed)].add_time(turn_time)
  sleep(1)

  # output scores
  (1..num_players).each do |i|
    puts "Player #{i} score: #{players_array[i].score}"
  end

  # print remaining cards in deck
  puts "Cards to be dealt: #{deck.cards_remaining}\n\n"
end

# game has ended, get final game time
elapsed_time = Time.now - start_time

# game over sequence
colorizer.write "\nGame Over! Final Stats:\n"
# output scores
(1..num_players).each do |i|
  colorizer.write "Player #{i} score: #{players_array[i].score}\n"
  colorizer.write "Player #{i} time taken: #{players_array[i].player_time} seconds\n"
end
colorizer.write "Total game time: #{elapsed_time}\n"

# checks if none of the players scored, i.e. no winner
all_scores_zero = true
players_array.each do |p|
  if p.score.positive?
    all_scores_zero = false
    break
  end
end

# print winner of the game
if num_players > 1 && !all_scores_zero
  colorizer.write "Congrats Player #{Player.max(players_array)}! You win!\n"
elsif num_players > 1 # tied game
  puts 'No one wins :('.red
end


