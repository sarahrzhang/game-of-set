require_relative './cards'
require_relative './deck'
require_relative './players'
require 'colorize'
require 'lolize'

# Game class to contain all game logic
class Game

  # check that 3 selected cards are a valid set
  def self.check_set(card1, card2, card3)
    # create hash containing all possible attribute
    attr_count = { 'red' => 0, 'blue' => 0, 'green' => 0, 'oval' => 0, 'wave' => 0, 'diamond' => 0, '1' => 0, '2' => 0, '3' => 0, 'solid' => 0, 'striped' => 0, 'blank' => 0 }
    selected_cards = [card1, card2, card3]
    # iterate over cards to count total occurrences of each attribute
    selected_cards.each do |card|
      attr_count[card.color] += 1
      attr_count[card.number] += 1
      attr_count[card.shading] += 1
      attr_count[card.shape] += 1
    end
    
    # if any attribute occurs exactly twice, there is no set
    attr_count.each do |_value|
      break if attr_count.value?(2) # loop breaks and returns nil
    end # if the cards form a set, the hash is returned
  end

  # find all possible sets currently on the board
  # returns true if there are sets, false if no more sets
  # runs cheat and hint functionality if prompted by user
  def self.find_set(deck, cheat_on, hint_on)
    final_res = false
    count = 0

    # create an array from 0 incrementing by 1
    cards_num_array = Array(0..deck.board.length - 1)
    # create a 2D array that lists all combos of size 3
    all_combos = cards_num_array.combination(3).to_a
    (0..all_combos.length-1).each do |i|
      # get 3 cards from one possible set combination
      card_a = deck.board[(all_combos[i][0])]
      card_b = deck.board[(all_combos[i][1])]
      card_c = deck.board[(all_combos[i][2])]

      # check if the 3 cards are a set
      if check_set(card_a, card_b, card_c) 
        count += 1 # increment set counter
        final_res = true # set return value to true
        if cheat_on # Cheat Function: display all existing sets on the board
          puts "\nCHEAT: Cards #{all_combos[i][0]+1}, #{all_combos[i][1]+1}, #{all_combos[i][2]+1}".colorize(:color => :white, :background => :red)
        end
      end
    end

    # output messages for Hint Generator and Cheat Function
    if cheat_on 
      puts "\nYou cheater. I'm disappointed. The #{count} sets are shown above.\n".red
    elsif hint_on # Hint Generator: display the number of sets on the board if hint is enabled
      puts "\nHINT: There are #{count} sets on the board.\n".white.on_green
    end
    final_res # returns whether there are sets on the board
  end

  # Game Over:
  # check that no more sets are on the board and the number of cards left in the deck is less than 3
  def self.game_over(deck)
    !find_set(deck, false, false) && deck.cards_remaining < 3
  end
end
