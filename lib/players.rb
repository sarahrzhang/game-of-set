require_relative './cards'
require_relative './deck'
require_relative './game'
require 'colorize'
require 'lolize'

MIN_BOARD_SIZE = 12

# Create all individual players and keep track of score
class Player
  attr_accessor :score, :player_num, :assigned_key, :player_time

  # initialize the number of players, assigned keys, and each player's score and time
  def initialize(player_num, assigned_key)
    @score = 0
    @player_num = player_num
    @assigned_key = assigned_key
    @player_time = 0.0
  end

  # add a point to when a set is found
  def score_point
    @score += 1
  end

  # calculate player's total turn time
  def add_time(turn_time)
    @player_time += turn_time
  end

  # ensure that a character is lowercase
  def self.lowercase_char(char_assigned)
    char_assigned.sum >= 97 && char_assigned.sum <= 122
  end

  # allow players to find a set of 3 cards 
  # verify whether the cards are a valid set or not
  # ensure that invalid input from the user does not break the game
  def player_turn(deck)
    res = false
    len = deck.board.length
    # loop until the user enters 3 valid card numbers
    until res
      puts 'Enter 3 non-duplicate card numbers, each followed by the ENTER key: '
      n1 = gets.chomp.to_i - 1
      n2 = gets.chomp.to_i - 1
      n3 = gets.chomp.to_i - 1
      # check that cards were not duplicates and had a valid index in the board
      if n1 != n2 && n1 != n3 && n2 != n3 && n1 < len && n2 < len && n3 < len && n1 >= 0 && n2 >= 0 && n3 >= 0
        res = true
      end
    end

    # update the board if a player finds a set
    if Game.check_set(deck.board[n1], deck.board[n2], deck.board[n3])
      # create colorizer to print rainbow text
      colorizer = Lolize::Colorizer.new
      colorizer.write "Nice work, you found a set!\n\n"
      score_point # update player's score
      # remove the set found
      deck.remove_cards(n1, n2, n3)
      # replace removed set with 3 new cards if at least 12 cards are not already present
      if deck.board.length < MIN_BOARD_SIZE && deck.cards_remaining.positive?
        deck.add_three_cards
      end
    else
      puts "Sorry, that is not a set.\n".red
    end
  end

  # find winner of game
  def self.max(players_array)
    max_score = 0
    best_time = -1
    index = -1
    # find the max score among all players of the game
    (0..players_array.length - 1).each do |i|
      if players_array[i].score > max_score || (players_array[i].score == max_score && players_array[i].player_time < best_time)
        max_score = players_array[i].score
        # get the best time in the case of a tie
        best_time = players_array[i].player_time
        index = i
          
      elsif players_array[i].score == max_score && players_array[i].player_time == best_time
        # If in the very rare case that players have the SAME score AND SAME TIME, we have a tie, so index = -1 (for test cases)
        index = -1
      end
    end
    index
  end
end
