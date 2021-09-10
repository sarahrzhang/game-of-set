#Testing cases for cards' program

require 'minitest/autorun' # the test runner
require_relative '../lib/cards.rb' # the UUT

class TestCard < MiniTest::Test

    # Set up the instances we need for testing
    def setup
        # This is a card with two red solid waves
        # color, shape, number, shading
        @card1 = Card.new(0, 1, 1, 0)  
        # This is a card with two green solid waves 
        @card2 = Card.new(1, 1, 1, 0) 
        # This is a card with two blue solid waves 
        @card3 = Card.new(2, 1, 1, 0) 
    end

    # Test to make sure that the card is being read properly
    # so that the output will be in the correct color
    def test_display_card_red
        assert_equal 'red', @card1.color
        assert_equal 'wave', @card1.shape
        assert_equal '2', @card1.number
        assert_equal 'solid', @card1.shading
    end

    def test_display_card_green
        assert_equal 'green', @card2.color
        assert_equal 'wave', @card2.shape
        assert_equal '2', @card2.number
        assert_equal 'solid', @card2.shading
    end

    def test_display_card_blue
        assert_equal 'blue', @card3.color
        assert_equal 'wave', @card3.shape
        assert_equal '2', @card3.number
        assert_equal 'solid', @card3.shading
    end
end
