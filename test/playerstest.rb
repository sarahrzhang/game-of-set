#Testing cases for players program

require 'minitest/autorun' # the test runner
require_relative '../lib/players.rb' # the UUT
require_relative '../lib/deck.rb'

class TestDeck < MiniTest::Test
    #Set up the instances we need for testing

    #Ask the team about to how to call the function and how to test the constructor
    def setup
        @player1 = Player.new(1, 'w')
        @player2 = Player.new(2, 'e')
        @player3 = Player.new(3, 'r')

        @deck = Deck.new
    end

    #Test if the score function works normally
    def test_score_point_case1 
        @player1.score_point      
        assert_equal 1, @player1.score
    end

    #Test if the score function works normally
    def test_score_point_case2
        @player1.score = 26
        @player1.score_point      
        assert_equal 27, @player1.score
    end

    #Test if add time works for individual player
    def test_add_time_case1
        start_time = @player1.player_time
        @player1.add_time(3)
        assert_equal (start_time+3), @player1.player_time
    end

    #Test if add time works for individual players parallelly
    def test_add_time_case2
        start_time = @player1.player_time
        start_time2 = @player2.player_time
        @player1.add_time(3)
        assert_equal (start_time+3), @player1.player_time
        assert_equal (start_time2), @player2.player_time
    end

    # player_turn just gets user input and calls check set and some
    # other methods that we have already tested, so we do not need 
    # to test it.

    #Test if everyone scores 0 (Edge Case) (no one wins, player score and time tied at 0)
    def test_self_max_case1
        players = [@player1, @player2, @player3]
        winnerIndex = Player.max(players)
        assert_equal -1, winnerIndex
    end

    #Test if player1 scores 1 (Normal Case)
    def test_self_max_case2
        players = [@player1, @player2, @player3]
        @player1.score = 1
        winnerIndex = Player.max(players)
        assert_equal 0, winnerIndex
    end

    #Test if player2 scores 1 (Edge Case) (when player score > 0 but tied and time is tied, no one wins)
    def test_self_max_case3
        players = [@player1, @player2, @player3]
        @player1.score = 1
        @player2.score = 1
        @player1.player_time = 3
        @player2.player_time = 3
        winnerIndex = Player.max(players)
        assert_equal -1, winnerIndex
    end

    #Test if player1 and player 2 have the same score but player1's time > player2's time
    def test_self_max_case4
        players = [@player1, @player2, @player3]
        @player1.score = 1
        @player2.score = 1
        @player1.player_time = 4
        @player2.player_time = 3
        winnerIndex = Player.max(players)
        assert_equal 1, winnerIndex
    end

    #Test if all players participated normally (win based on time)
    def test_self_max_case5
        players = [@player1, @player2, @player3]
        @player1.score = 1
        @player2.score = 1
        @player3.score = 1
        @player1.player_time = 4
        @player2.player_time = 3
        @player3.player_time = 2
        winnerIndex = Player.max(players)
        assert_equal 2, winnerIndex
    end

    #Test if all players participated normally (win based on score)
    def test_self_max_case6
        players = [@player1, @player2, @player3]
        @player1.score = 1
        @player2.score = 2
        @player3.score = 3
        @player1.player_time = 4
        @player2.player_time = 3
        @player3.player_time = 2
        winnerIndex = Player.max(players)
        assert_equal 2, winnerIndex
    end

end
