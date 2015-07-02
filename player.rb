require 'io/console'

class Player
  ARROWS = ["\e[A", "\e[B", "\e[C", "\e[D"]
  attr_reader :board

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def get_move
    origin = get_pos

  end

  def get_pos
    action = nil
    until action == " "
      action = get_movement
      abort("Bye") if action == "q"
      next unless ARROWS.include?(action)
      board.map_deltas(action)
      system("clear")
      board.display
    end
  end

  def get_movement
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end
end
