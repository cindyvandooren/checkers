require 'byebug'
require_relative 'emptysquares'
require_relative 'piece'
require 'colorize'

class Board
  CURSOR_DELTAS = {
                 "\e[A" => [-1, 0],
                 "\e[B" => [ 1, 0],
                 "\e[C" => [ 0, 1],
                 "\e[D" => [ 0,-1]
                 }

  attr_reader :sentinel, :cursor, :selected_piece

  def initialize(setup=true)
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    @setup = setup
    @sentinel = EmptySquare.new
    @cursor = [0, 0]
    @selected_piece = 0
    populate if setup
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def make_move(origin, destination)
    dx = destination.first - origin.first
    dy = destination.first - origin.first

    if dx.abs > 1 && dy.abs > 1
      jumped_piece_pos = [origin.first + dx / 2, origin.last + dx / 2]
      self[jumped_piece_pos] = sentinel
    end
    self[origin].pos = destination
    self[destination] = self[origin]
    self[origin] = sentinel
  end

  def map_deltas(action)
    future_cursor = cursor.map.with_index do |el, i|
      el + CURSOR_DELTAS[action][i]
    end
    return unless on_board?(future_cursor)

    @cursor = future_cursor
  end

  def display
    display_header
    display_actual_board
    display_header
    puts "selected_piece #{selected_piece}"
  end

  def display_header
    puts "   #{("a".."h").to_a.join("  ")}"
  end

  def display_actual_board
    (0...8).each do |row_n|
      print_row = []
      last_white = row_n.even? ? false : true
      (0...8).each do |col_n|
        pos = [row_n, col_n]
        if cursor == pos
          color = :white
        elsif last_white
          color = :cyan
        else
          color = :magenta
        end
        print_row << self[pos].to_s.colorize(background: color)
        last_white = !last_white
      end
      print_row.unshift("#{8 - row_n} ")
      print_row.push(" #{8 - row_n}")
      puts print_row.join
    end
  end

  def deep_dup
    new_board = Board.new(false)

    (0...8).each do |row_n|
      (0...8).each do |col_n|
        pos = [row_n, col_n]
        self[pos] = self[pos].dup(new_board)
      end
    end

    new_board
  end

  def remove_piece(pos)
    self[pos] = sentinel
  end

  def occupied?(pos)
    !self[pos].empty?
  end

  def on_board?(pos)
    pos.all? { |el| el.between?(0, 7) }
  end

  def one_color?(color)
    #are all the pieces on the board of the same color
  end

  def toggle_select
    @selected_piece = selected_piece == 0 ? cursor : 0
  end

  private

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
end
