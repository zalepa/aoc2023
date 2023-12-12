# frozen_string_literal: true

require_relative '../test_helper.rb'
require './lib'

class Day11Test < Minitest::Test
  def setup
    raw = File.read('./sample.txt')
    @space = Space.new(raw)
  end

  def test_it_builds_an_initial_grid
    assert_equal 10, @space.height
    assert_equal 10, @space.width
  end

  def test_it_can_expand_space
    @space.expand
    assert_equal 12, @space.height
    assert_equal 13, @space.width
    assert_equal '....#........', @space.cells[0].join
    assert_equal '.........#...', @space.cells[1].join
  end

  def test_it_can_return_galaxy_coordinates
    @space.expand
    assert_equal [[0, 4], [1, 9], [2, 0], [5, 8], [6, 1], [7, 12], [10, 9], [11, 0], [11, 5]], @space.galaxy_coordinates
  end

  def test_manhattan_distance
    assert_equal 3, Space.manhattan_distance([1, 6], [-1, 5])
  end

  def test_it_can_permutate_manhattan_distances
    @space.expand
    assert_equal 374, @space.total_distances
  end

  def test_sim_expansion
    @space.expand(sim: true)
    assert_equal '..X#.X..X.', @space.cells[0].join
    assert_equal 'XXXXXXXXXX', @space.cells[3].join
  end

  def test_distance_with_simulation
    @space.expand(sim: true, amount: 2)
    assert_equal [[0, 3], [1, 8]], @space.adjust_pairs([[0, 3], [1, 7]])
    assert_equal [[0, 3], [11, 4]], @space.adjust_pairs([[0, 3], [9, 4]])
    assert_equal [[2,0 ], [7,12]], @space.adjust_pairs([[2, 0], [6,9]])
    assert_equal [[6,9 ], [2,0 ]], @space.adjust_pairs([[6,9], [2, 0]])
  end

  def test_total_distance_with_simulation
    @space.expand(sim: true, amount: 10)
    assert_equal 1030, @space.total_distances(sim: true)
  end
end