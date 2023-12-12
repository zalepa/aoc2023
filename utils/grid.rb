# frozen_string_literal: true

# A re-usable class for AoC grid operations
class Grid
  attr_reader :height, :width, :cells

  include Enumerable

  def initialize(str)
    @height = str.split(/\n/).count
    @width  = str.split(/\n/)[0].length
    @cells = Array.new(@height)
    populate_cells(str)
  end

  def each
    @cells.each.with_index do |row, i|
      row.each.with_index do |cell, j|
        yield cell, i, j
      end
    end
  end

  # @param [Integer] row
  # @param [Integer] col
  # @return [Any] the value at (col, row)
  def [](row, col)
    return nil if row.negative?
    return nil if row > @width - 1
    return nil if col > @height - 1
    return nil if col.negative?

    @cells[row][col]
  end

  def []=(row, col, val)
    return nil if row.negative?
    return nil if row > @width - 1
    return nil if col > @height - 1
    return nil if col.negative?

    @cells[row][col] = val
  end

  # @param [Object] x_pos
  # @param [Object] y_pos
  def neighbors(x_pos, y_pos)
    [
      neighbors_above(x_pos, y_pos),
      neighbors_side(x_pos, y_pos),
      neighbors_below(x_pos, y_pos)
    ]
  end

  def get_left_from(x_pos, y_pos)
    return [] if y_pos.zero?

    0.upto(y_pos - 1).map { @cells[x_pos][_1] }
  end

  def get_right_from(x_pos, y_pos)
    return [] if y_pos == @width - 1

    (y_pos + 1).upto(@width - 1).map { @cells[x_pos][_1] }
  end

  def get_above_from(x_pos, y_pos)
    return [] if x_pos.zero?

    0.upto(x_pos - 1).map { @cells[_1][y_pos] }
  end

  def get_below_from(x_pos, y_pos)
    return [] if x_pos == @height - 1

    (x_pos + 1).upto(@height - 1).map { @cells[_1][y_pos] }
  end

  private

  def populate_cells(str)
    str.split(/\n/).each.with_index do |r, i|
      @cells[i] = []
      r.split('').each.with_index do |c, j|
        @cells[i][j] = c
      end
    end
  end

  def neighbors_above(x_pos, y_pos)
    [self[x_pos - 1, y_pos - 1], self[x_pos - 1, y_pos], self[x_pos - 1, y_pos + 1]]
  end

  def neighbors_below(x_pos, y_pos)
    [self[x_pos + 1, y_pos - 1], self[x_pos + 1, y_pos], self[x_pos + 1, y_pos + 1]]
  end

  def neighbors_side(x_pos, y_pos)
    [self[x_pos, y_pos - 1], nil, self[x_pos, y_pos + 1]]
  end
end
