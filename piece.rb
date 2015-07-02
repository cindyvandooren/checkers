class Piece
  WHITE_DELTAS = [[1, -1], [1, 1]]

  BLACK_DELTAS = [[-1, -1], [-1, 1]]

  attr_reader :color, :pos, :king, :board

  def initialize(pos, color, board, king=false)
    @pos = pos
    @color = color
    @board = board
    @king = false
  end

  def perform_slide(destination)
    #slide (one move) is possible when:
    #the (dx, dy) between origin and destination are in the piece.move_diffs and there is no other piece in the destination.
    dx = destination.first - pos.first
    dy = destination.last - pos.last

    move_diffs.include?([dx, dy]) && !board.occupied?(destination)
  end

  def perform_jump(destination)
    return false if board.occupied?(destination)
    #illegal jump (one move) should return false, else true
    #jump can be made when the (dx, dy) between origin and destination are in the piece.move_diffs, there is no piece in the destination and there is a piece of the other color in the spot where it jumps over
    dx = (destination.first - pos.first) / 2
    dy = (destination.first - pos.first) / 2
    pos_jumped_piece = [pos + dx, pos + dy]

    move_diffs.include?([dx, dy]) && board[pos_jumped_piece].color == other_color
  end

  def move_diffs
    case
    when king
      WHITE_DELTAS + BLACK_DELTAS
    when color == :white
      WHITE_DELTAS
    when color == :black
      BLACK_DELTAS
    end
  end

  def maybe_promote

  end

  def dup(duped_board)
    Piece.new(pos.dup, color, duped_board, king)
  end

  def empty?
    false
  end

  def other_color
    color == :white ? :black : :white
  end

  def to_s
    #used to display the piece on the board
    if color == :white
      king ? " WK " : " W "
    else
      king ? " BK " : " B "
    end
  end
end
