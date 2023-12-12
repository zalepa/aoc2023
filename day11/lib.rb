# frozen_string_literal: true

require_relative '../utils/grid'

class Space < Grid
  # Manhattan distance calculation
  def self.manhattan_distance(point1, point2)
    (point1[0] - point2[0]).abs + (point1[1] - point2[1]).abs
  end

  # Expand rows and columns of a universe
  def expand(opts={})
    @sim_amount = opts[:amount] if opts[:amount]
    expand_height(opts)
    expand_width(opts)
  end

  # Return, as an array, arrays of galaxy coordinates
  def galaxy_coordinates
    map do |val, row, col|
      [row, col] if val == '#'
    end.compact
  end

  def total_distances(opts={})
    galaxy_coordinates.combination(2).map do |pair|
      opts[:sim] ? simulate_total_distance(pair) : total_distance(pair)
    end.inject(&:+)
  end

  # Calculate the distance based assuming an expanded grid
  def total_distance(pair)
    Space.manhattan_distance(pair[0], pair[1])
  end

  def adjust_pairs(pair)
    # pp pair
    x1, y1 = pair.first
    x2, y2 = pair.last

    # First, compute how many Xs are between x1 and x2. This
    # corresponds to the vertical direction
    vertical_distance_adjustment = 0
    cells = []
    if x1 < x2 
      (x1 + 1).upto(x2) { cells << self[_1, y1] }
    else
      (x2 + 1).upto(x1) { cells << self[_1, y2] }
    end

    vertical_distance_adjustment = cells.count { _1 == 'X' } * @sim_amount - cells.count { _1 == 'X' }
    
    # First, compute how many Xs are between y1 and y2. This
    # corresponds to the horizontal direction
    horizontal_distance_adjustment = 0
    cells = []
    if y1 < y2 
      (y1 + 1).upto(y2 - 1) { cells << self[x1, _1] }
    else
      (y2 + 1).upto(y1 - 1) { cells << self[x2, _1] }
    end
    horizontal_distance_adjustment = cells.count { _1 == 'X' } * @sim_amount - cells.count { _1 == 'X' }
   

    if x1 < x2
      x2 += vertical_distance_adjustment
    else
      x1 += vertical_distance_adjustment
    end

    if y1 < y2 
      y2 += horizontal_distance_adjustment
    else
      y1 += horizontal_distance_adjustment
    end
    
    return [[x1, y1], [x2, y2]]
    # First, compute how much space is actually between x coordinates
    
  end

  # Simulate a total distance
  # First, we need to see how many X's are in the row/column direction
  # then based on the "amount" variable, re-compute the paratmers 
  # then execut manhattan distance
  def simulate_total_distance(pair)
    pair = adjust_pairs(pair)
    total_distance(pair)
  end

  private

  # Expand the width of the grid based on columns only including '.' values
  def expand_width(opts={})
    column_indexes_with_no_galaxies.each do |idx|
      @cells.each do |row|
        opts[:sim] ? row[idx] = 'X' : row.insert(idx, '.') 
      end
    end
    @width = @cells[0].count
  end

  # Expand the height of the grid based on rows only including '.' values
  def expand_height(opts={})
    indices = @cells.map.with_index do |row, index|
      index unless row.include?('#')
    end.compact
    indices.reverse.each do |idx|
      if opts[:sim]
        @cells[idx].map! { 'X' } 
      else
        @cells.insert(idx, Array.new(@width, '.')) 
      end
    end
    @height = @cells.count
  end

  # Returns a list of integers representing the columns without galaxies
  def column_indexes_with_no_galaxies
    indices = []
    0.upto(@width - 1) do |col|
      column = @cells.map { _1[col] }
      indices << col unless column.include?('#')
    end
    indices.reverse
  end
end