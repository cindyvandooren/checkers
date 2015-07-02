require 'byebug'
require_relative 'emptysquares'
require_relative 'piece'

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    populate
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def populate
    color = nil
    col_numbers = (0...8).to_a

    [0, 1, 2, 5, 6, 7].each do |row_n|
        if [0, 1, 2].include?(row_n)
          color = :white
        elsif [5, 6, 7].include?(row_n)
          color = :black
        end

        if row_n.even?
          col_numbers.select { |col_n| col_n.odd? }.each do |col_n|
            pos = [row_n, col_n]
            self[pos] = Piece.new(pos, color, self)
          end
        else
          col_numbers.select { |col_n| col_n.even? }.each do |col_n|
            pos = [row_n, col_n]
            self[pos] = Piece.new(pos, color, self)
          end
        end
      end
    end

  def display
    @grid.each do |row|
      print_row = []
      row.each do |square|
        print_row << square.to_s
      end
      puts print_row.join()
    end
  end
end

a = Board.new
a.display
