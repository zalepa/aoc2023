# frozen_string_literal: true

require_relative '../utils/grid'

# A Maze class
class Maze < Grid
  # Find or return the starting position within the grid
  def starting_position
    @starting_position ||= find { _1.first == 'S' }[1..]
  end

  # Get a list of connected neighboring pipes
  def connected_neighbors(position, opts = {})
    x, y = position
    active_cell = self[x, y]

    north = self[x - 1, y]
    south = self[x + 1, y]
    east  = self[x, y + 1]
    west  = self[x, y - 1]

    if opts[:debug]
      pp active_cell
      pp x, y
      pp north
      pp south
      pp east
      pp west
    end

    vals = []

    case active_cell
    when 'S'
      vals << [x - 1, y, north] if !north.nil? && north.match(/[|7F]/)
      vals << [x + 1, y, south] if !south.nil? && south.match(/[|JL]/)
      vals << [x, y + 1, east]  if !east.nil?  && east.match(/[-J7]/)
      vals << [x, y - 1, west]  if !west.nil?  && west.match(/[-FL]/)
    when '|'
      vals << [x - 1, y, north] if !north.nil? && north.match(/[|7F]/)
      vals << [x + 1, y, south] if !south.nil? && south.match(/[|JL]/)
    when '-'
      vals << [x, y + 1, east]  if !east.nil?  && east.match(/[-J7]/)
      vals << [x, y - 1, west]  if !west.nil?  && west.match(/[-FL]/)
    when 'L'
      vals << [x - 1, y, north] if !north.nil? && north.match(/[|7F]/)
      vals << [x, y + 1, east]  if !east.nil?  && east.match(/[-J7]/) 
    when 'J'
      vals << [x - 1, y, north] if !north.nil? && north.match(/[|7F]/)
      vals << [x, y - 1, west]  if !west.nil?  && west.match(/[-FL]/)
    when '7'
      vals << [x, y - 1, west]  if !west.nil?  && west.match(/[-FL]/)
      vals << [x + 1, y, south] if !south.nil? && south.match(/[|JL]/)
    when 'F'
      vals << [x + 1, y, south] if !south.nil? && south.match(/[|JL]/)
      vals << [x, y + 1, east]  if !east.nil?  && east.match(/[-J7]/)
    end
    
    vals
  end

  def walk_pipe(opts = {})

    pos = opts[:from] || starting_position
    pp "Initial pos: #{pos}" if opts[:debug]
    visited = []

    candidates = connected_neighbors(pos)
    pp candidates  if opts[:debug]
    until (candidates - visited).empty?
      pos = (candidates - visited).sample
      pp "Chosen: #{pos.last} at #{pos[0]}, #{pos[1]}"  if opts[:debug]
      visited << pos
      candidates = connected_neighbors(pos)
      pp candidates  if opts[:debug]
    end

    visited
  end

  def walk_pipe!(opts = {})

    pos = opts[:from] || starting_position
    pp "Initial pos: #{pos}" if opts[:debug]
    visited = []

    candidates = connected_neighbors(pos)
    pp candidates  if opts[:debug]
    until (candidates - visited).empty?
      pos = (candidates - visited).sample
      pp "Chosen: #{pos.last} at #{pos[0]}, #{pos[1]}"  if opts[:debug]
      visited << pos
      candidates = connected_neighbors(pos)
      self[pos[0], pos[1]] = 'X'
      pp candidates if opts[:debug]
    end

    visited
  end

  def infill
    each do |val, row, col|
      next if val == 'X'
      left = get_left_from(row, col)
      right = get_right_from(row, col)
      up = get_above_from(row, col)
      down = get_below_from(row, col)
      if left.include?('X') && right.include?('X') && up.include?('X') && down.include?('X')
        self[row, col] = '◌'
      else
        self[row, col] = '.'
      end
    end
  end
end
