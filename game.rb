require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board, :players

  def initialize
    @board = Board.new
    @players = [Player.new("B", :black, board), Player.new("W", :white, board)]
  end

  def run
    game_over = false
    until game_over
      take_turn
    end

    finish_message
  end

  def take_turn
    #player makes the first move
    # system("clear")
    board.display
    puts "It is #{players.first.name}'s turn'"
    origin, destination = players.first.get_move
    #let the board perform the move
    board.make_move(origin, destination)


    #players rotate, so now it is the next players turn
    players.rotate!
  end

  def finish_message
    puts "Needs to be implemented"
  end

  def over?
    #The game is over when there are no pieces on the board of a certain color. So all the pieces on the board have the same color.
  end

end

game = Game.new
game.run
