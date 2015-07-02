class Piece
  WHITE_DELTAS = [[1, -1], [1, 1]]

  BLACK_DELTAS = [[-1, -1], [-1, 1]]

  attr_reader :color, :pos, :king

  def initialize(pos, color, board, king=false)
    @pos = pos
    @color = color
    @board = board
    @king = false
  end

  def perform_slide(origin, destination)
    #illegal slide should return false, else true
    #needs to check if the piece can be promoted to king
    #a slide can be performed when: 1) the (dx, dy) between origin and destination are in the piece.move_diffs and there is no other piece in the destination.
    #Not sure if dup of the board is needed.
    
  end

  def perform_jump
    #illegal slide should return false, else true
    #should remove jumped piece from the board
    #needs to check if the piece can be promoted to king
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

  def to_s
    #used to display the piece on the board
    if color == :white
      "W"
    else
      "B"
    end
  end
end
