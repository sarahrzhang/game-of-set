require_relative './cards'
require_relative './game'
require 'colorize'
require 'lolize'

class Deck
  attr_accessor :board
  attr_reader :deck

  # Initialize all 81 cards into the deck
  def initialize
    @deck = []
    @board = []
    (0..2).each do |color|
      (0..2).each do |shape|
        (0..2).each do |number|
          (0..2).each do |shading|
            @deck << Card.new(color, shape, number, shading)
          end
        end
      end
    end
  end

  # shuffle the deck
  def shuffle_deck
    @deck.shuffle!
  end

  # remove the first card from the array
  def draw_card
    @deck.shift
  end

  # keep track of how many cards are left in the deck
  def cards_remaining
    @deck.length
  end

  # update the board to display 12 cards at the beginning of the game
  def draw_twelve
    (0..11).each do |_n|
      card = draw_card
      @board << card
    end
  end

  # print the card numbers and attributes of each card to the board
  def display_board
    # create colorizer to print rainbow text
    colorizer = Lolize::Colorizer.new 
    # print each card and its attributes
    (0..@board.length - 1).each do |n|
      colorizer.write "\tCard #{n + 1}\t"
      @board[n].display_card
    end
  end

  # remove three cards from the board after a set is found
  def remove_cards(card1, card2, card3)
    # sort indicies smallest to largest
    indicies = [card1, card2, card3].sort
    # remove from board starting with largest card
    @board.delete_at(indicies[2])
    @board.delete_at(indicies[1])
    @board.delete_at(indicies[0])
  end

  # update the board to add three cards after a set is taken out
  def add_three_cards
    (0..2).each do |_n|
      card = draw_card
      @board << card
    end
  end
end
