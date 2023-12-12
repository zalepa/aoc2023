# frozen_string_literal: true

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative './lib'

class Day10Test < Minitest::Test
  def setup
    @raw = File.read('./sample2.txt')
    @grid = Maze.new(@raw)
  end

  def test_grid_properties
    assert @grid.height == 5
    assert @grid.width
    assert @grid.cells.flatten.count == 5 * 5
  end

  def test_find_starting_position
    assert_equal [2, 0], @grid.starting_position
  end

  def test_get_connected_neighbors
    starting_position = @grid.starting_position
    assert_equal 2, @grid.connected_neighbors(starting_position).count
    assert_equal 1, @grid.connected_neighbors([2, 1]).count
    assert_equal 2, @grid.connected_neighbors([1, 1]).count
    assert_equal 2, @grid.connected_neighbors([1, 2]).count
    assert_equal 2, @grid.connected_neighbors([0, 2]).count
    assert_equal 2, @grid.connected_neighbors([0, 3]).count
    assert_equal 2, @grid.connected_neighbors([1, 3]).count
    # assert_equal [[1, 2, '-'], [2, 1, '|']], @grid.connected_neighbors(starting_position)
  end

  def test_walk_pipe
    pipe = @grid.walk_pipe(from: @grid.starting_position)
    assert_equal 15, pipe.length
  end
end
