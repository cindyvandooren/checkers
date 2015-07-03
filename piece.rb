class Piece
  WHITE_DELTAS = [[1, -1], [1, 1]]

  BLACK_DELTAS = [[-1, -1], [-1, 1]]

  attr_reader :color, :king, :pos
  attr_accessor :board

  def initialize(pos, color, board, king=false)
    @pos = pos
    @color = color
    @board = board
    @king = false
  end

  def perform_moves!(move_sequence, duped_board)
    #performs the moves one by one. If a move in the sequence fails an InvalidMoveError should be raised.
    #if the sequence is one move long try sliding, if that doesn't work try jumping
    #if the sequence is multiple moves long, every move must be a jump
    if move_sequence.count <= 1
      next_move = move_sequence.shift
      if perform_slide?(next_move) || perform_jump?(next_move)
        duped_board.make_move(pos, next_move)
      else
        raise InvalidMoveError
      end
    else
      until move_sequence.empty?
        next_move = move_sequence.shift
        if perform_jump?(next_move)
          duped_board.make_move(pos, next_move)
        else
          raise InvalidMoveError
        end
      end
    end
  end

  def valid_move_seq?(move_sequence)
    #calls perform_moves! on a duped board and if no error is raised it returns true, else false
    duped_board = Board.new(false)
    begin
      perform_moves!(move_sequence, duped_board)
    rescue InvalidMoveError
      return false
    else
      return true
    end
  end

  def perform_moves(move_sequence, board)
    if valid_move_seq?(move_sequence)
      perform_moves(move_sequence, board)
    else
      raise InvalidMoveError
    end
  end

  def perform_slide?(destination)
    #slide (one move) is possible when:
    #the (dx, dy) between origin and destination are in the piece.move_diffs and there is no other piece in the destination.
    dx = destination.first - pos.first
    dy = destination.last - pos.last
    puts "in slide"
    puts "destination #{destination}"
    puts "pos #{pos}"
    puts "dx #{dx}"
    puts "dy #{dy}"

    move_diffs.include?([dx, dy]) && !board.occupied?(destination)
  end

  def perform_jump?(destination)
    return false if board.occupied?(destination)
    #illegal jump (one move) should return false, else true
    #jump can be made when the (dx, dy) between origin and destination are in the piece.move_diffs, there is no piece in the destination and there is a piece of the other color in the spot where it jumps over
    dx = (destination.first - pos.first) / 2
    dy = (destination.last - pos.last) / 2
    pos_jumped_piece = [pos.first + dx, pos.last + dy]
    puts "in jump"
    puts "destination #{destination}"
    puts "pos #{pos}"
    puts "dx #{dx}"
    puts "dy #{dy}"
    puts "pos_jumped_piece #{pos_jumped_piece}"
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
    #We want to promote a piece if the piece gets to the other side of the board. For a black piece this is, when it reaches row 0, for a white piece, it needs to reach row 7.

    end_row_number = color == :white ? 7 : 0
    puts "end_row_number #{end_row_number}"
    @king = true if pos.first == end_row_number

  end

  def dup(duped_board)
    Piece.new(pos.dup, color, duped_board, king)
  end

  def empty?
    false
  end

  def set_position(new_pos)
    @pos = new_pos
  end

  def other_color
    if self.color == :white
      :black
    else
      :white
    end
  end

  def to_s
    #used to display the piece on the board
    if color == :white
      king ? "WK " : " W "
    else
      king ? "BK " : " B "
    end
  end
end
