class EmptySquare
  def dup(duped_board)
    EmptySquare.new
  end

  def empty?
    true
  end

  def to_s
    "_"
  end
end
