require 'io/console'

class Player
  ARROWS = ["\e[A", "\e[B", "\e[C", "\e[D"]

  attr_reader :board, :color, :name

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def get_move
    begin
      origin = get_pos
      until valid_origin?(origin)
        origin = get_pos
      end

      board.toggle_select
      destination = find_destination(origin)
    rescue InvalidMoveError
      board.toggle_select
      retry
    end
    board.toggle_select

    [origin, destination]
  end

  def find_destination(origin)
    destination = get_pos
    until valid_destination?(origin, destination)
      destination = get_pos
    end

    destination
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

    board.cursor
  end

  def valid_origin?(pos)
    board[pos].color == color
  end

  def valid_destination?(origin, destination)
    raise InvalidMoveError if origin == destination
    board[origin].perform_slide?(destination) || board[origin].perform_jump?(destination)
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
