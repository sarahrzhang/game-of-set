#Testing cases for game program

require 'minitest/autorun' # the test runner
require_relative '../lib/game.rb' # the UUT
require_relative '../lib/deck.rb'

class TestGame < MiniTest::Test
    def setup
        @deck = Deck.new

        # cards 1-3 make a set, but cards 2-6 do not have any
        @card1 = Card.new(0, 1, 1, 0)  
        @card2 = Card.new(1, 1, 1, 0)  
        @card3 = Card.new(2, 1, 1, 0) 
        @card4 = Card.new(2, 2, 1, 0) 
        @card5 = Card.new(2, 2, 2, 0)
        @card6 = Card.new(2, 2, 2, 1)  
    end

    # check_set returns nil if it is not a set
    # check_set returns a value if the 3 cards given is a set
    def test_check_set_true
        # cards 1, 2 and 3 are a set
        result = Game.check_set(@card1, @card2, @card3)
        refute_nil result
    end

    # make sure that card ordering does not matter
    def test_check_set_true2
        # cards 1, 2 and 3 are a set
        result = Game.check_set(@card3, @card1, @card2)
        refute_nil result
    end

    # we want the result to be nil if there is not a set
    def test_check_set_false
        # cards 2, 3 and 4 are NOT a set
        result = Game.check_set(@card2, @card3, @card4)
        assert_nil result
    end

    # we want the result to be nil if there is not a set
    def test_check_set_false_duplicate
        # cards 2, 2 and 4 are NOT a set
        result = Game.check_set(@card2, @card2, @card4)
        assert_nil result
    end

    # we do not need to test check_set for duplicate cards 
    # because the logic in player_turn prevents duplicates
    # from being entered

    # once again make sure ordering does not matter
    def test_check_set_false2
        # cards 2, 3 and 4 are NOT a set
        result = Game.check_set(@card3, @card4, @card2)
        assert_nil result
    end

    # In this case, it returns true bc there is at least one
    # set on the board
    def test_find_set_true
        # this puts 12 cards on the board
        @deck.draw_twelve
        # In this case there should be 13 sets on the board, 
        # because we have not shuffled the deck, and there
        # are 13 sets in the first 12 unshuffled cards dealt
        # (calculated manually)
        result = Game.find_set(@deck, false, false)
        assert_equal true, result

    end

    #cards on the board and only 1 set, true
    def test_find_set_true_1
        @deck.board = [@card1, @card3, @card2]
        result = Game.find_set(@deck, false, false)
        assert_equal true, result
    end

    # no cards on the board case
    def test_find_set_false_no_cards_on_board
        result = Game.find_set(@deck, false, false)
        assert_equal false, result
    end
    
    # 3 cards on the board but no set
    def test_find_set_false3
        @deck.board = [@card2, @card3, @card4]
        result = Game.find_set(@deck, false, false)
        assert_equal false, result
    end

    # 5 cards on the board but no set
    def test_find_set_false5
        @deck.board = [@card2, @card3, @card4, @card6, @card5]
        result = Game.find_set(@deck, false, false)
        assert_equal false, result
    end

    # when testing game over, we want to make sure it returns
    # FALSE unless there are no cards in the deck AND no sets
    # on the board.

    # the game has just begun in this case
    def test_game_over_beginning
        result = Game.game_over(@deck)
        assert_equal false, result
    end

    # the game has just begun in this case, and set on board.
    def test_game_over_case2
        @deck.draw_twelve
        result = Game.game_over(@deck)
        assert_equal false, result
    end

    # there are no cards remaining, but there is a set on board.
    def test_game_over_case3
        (1..27).each do 
            @deck.add_three_cards
        end
        result = Game.game_over(@deck)
        assert_equal false, result
    end

    # there are no cards remaining and no set on board, game over 
    # true
    def test_game_over_case4
        # make sure no cards in the deck
        (1..27).each do 
            @deck.add_three_cards
        end
        # there are no sets in the board
        @deck.board = [@card2, @card3, @card4, @card6, @card5]
        result = Game.game_over(@deck)
        assert_equal true, result
    end

    # no cards on the deck or board, game over is true
    def test_game_over_case5
        # make sure no cards in the deck
        (1..27).each do 
            @deck.add_three_cards
        end
        # there are no cards in the board
        @deck.board = []
        result = Game.game_over(@deck)
        assert_equal true, result
    end
    
end
