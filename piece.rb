class Piece
  attr_reader :color, :pos, :king

  def initialize(pos, color, board, king=false)
    @pos = pos
    @color = color
    @board = board
    @king = false
  end

  def perform_slide
    #illegal slide should return false, else true
    #needs to check if the piece can be promoted to king
  end

  def perform_jump
    #illegal slide should return false, else true
    #should remove jumped piece from the board
    #needs to check if the piece can be promoted to king
  end

  def move_diffs
    #returns directions a piece can move in
  end

  def maybe_promote

  end

  def dup(duped_board)
    Piece.new(pos.dup, color, duped_board, king)
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
