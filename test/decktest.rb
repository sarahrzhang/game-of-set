#Testing cases for deck program

require 'minitest/autorun' # the test runner
require_relative '../lib/deck.rb' # the UUT

class TestDeck < MiniTest::Test

    #Set up the instances we need for testing
    def setup
        @deck = Deck.new
        @tmp_array = Deck.new 
    end

    def test_initialize 
        assert_equal 81, @deck.deck.length
        assert_equal 0, @deck.board.length
    end

    #Check if cards_remaining function works or not 
    #cards_remaining function basically returns the length of the deck
    def test_cards_remaining_case1
        assert_equal 81, @deck.cards_remaining
        @deck.shuffle_deck
        assert_equal 81, @deck.cards_remaining
        @deck.draw_twelve
        assert_equal 69, @deck.cards_remaining
        @deck.draw_card
        assert_equal 68, @deck.cards_remaining
        (1..68).each do 
            @deck.draw_card
        end
        assert_equal 0, @deck.cards_remaining
    end

    #Check if cards_remaining function works or not if the deck is
    def test_cards_remaining_case2
        (1..81).each do 
            @deck.draw_card
        end
        assert_equal 0, @deck.cards_remaining
    end

    #Check if draw_card function works normally
    def test_draw_card_case1
        assert_equal 81, @deck.deck.length
        @deck.draw_card
        assert_equal 80, @deck.deck.length
    end

    #draw_card edge cases
    #check if draw_card function will break if you try to draw card but there is 0 card in the deck
    def test_draw_card_case2
        (0..80).each do 
            @deck.draw_card
        end
        assert_empty @deck.deck
        assert_nil @deck.draw_card
    end

    #We do not need edge case for draw_twelve function since we only call it once at the beginning in the main
    def test_draw_twelve
        assert_equal 81, @deck.deck.length
        assert_equal 0, @deck.board.length
        @deck.draw_twelve
        assert_equal 69, @deck.deck.length
        assert_equal 12, @deck.board.length
    end

    #Ask Sarah bout console printing
    def test_display_board
        
    end
    
    #Test remove_cards function to make sure it removes 3 cards and it removes the correcr cards
    #Remove cards is only called when there is at least 3 cards in the board so we do not need to test when there is fewer than 3 cards on the board
    #Therefore, we do not need an edge case for this function.
    def test_remove_cards_Case1
        copy_array = ["str1","str2","str3","str4","str5"]
        @tmp_array.board = ["str1","str2","str3","str4","str5"]
        @tmp_array.remove_cards(0,1,2)
        assert_equal 2, @tmp_array.board.length
        refute_includes @tmp_array.board, copy_array[0]
        refute_includes @tmp_array.board, copy_array[1]
        refute_includes @tmp_array.board, copy_array[2]
    end

    #Check if the order of the parameters (card index) the user entered does not matter
    def test_remove_cards_Case1
        copy_array = ["str1","str2","str3","str4","str5"]
        @tmp_array.board = ["str1","str2","str3","str4","str5"]
        @tmp_array.remove_cards(4,1,2)
        assert_equal 2, @tmp_array.board.length
        refute_includes @tmp_array.board, copy_array[2]
        refute_includes @tmp_array.board, copy_array[1]
        refute_includes @tmp_array.board, copy_array[4]
    end
 
    #Check if add_three cards will move 3 cards from the deck to the board when the deck is full (Normal case)
    def test_add_three_cards
        assert_equal 81, @deck.deck.length
        assert_equal 0, @deck.board.length
        @deck.add_three_cards
        assert_equal 78, @deck.deck.length
        assert_equal 3, @deck.board.length
    end

    #Check if add_three cards will move 3 cards until the deck is empty and the board is full (Edge case)
    def test_add_three_cards
        (1..27).each do 
            @deck.add_three_cards
        end
        assert_equal 0, @deck.deck.length
        assert_equal 81, @deck.board.length
    end

    #Check if add_three cards will still move 3 cards if the deck is empty and the board is full (Edge case)
    def test_add_three_cards
        (1..27).each do 
            @deck.add_three_cards
        end
        @deck.add_three_cards
        assert_empty @deck.deck
        assert_nil @deck.draw_card
    end
end
