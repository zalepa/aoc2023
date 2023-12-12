# frozen_string_literal: true

require 'minitest/autorun'
require_relative './grid'

# Test for the Grid class
class TestGrid < Minitest::Test
  def setup
    @grid = Grid.new("123\n456\n789")
  end

  def test_sets_height
    assert_equal 3, @grid.height
  end

  def test_sets_width
    assert_equal 3, @grid.width
  end

  def test_sets_cells
    assert_equal [%w[1 2 3], %w[4 5 6], %w[7 8 9]], @grid.cells
  end

  def test_responds_to_each
    assert @grid.respond_to? :each
  end

  def test_each_cell_iterates_through_cells
    expected = %w[1 2 3 4 5 6 7 8 9]
    assert_equal expected, @grid.map { _1 }
  end

  def test_supports_bracket_reading
    assert_equal '1', @grid[0, 0]
  end

  def test_supports_bracket_reading_returning_nil_for_out_of_bounds_reads
    assert_nil @grid[-1, 0]
    assert_nil @grid[0, -1]
    assert_nil @grid[0, @grid.width + 1]
    assert_nil @grid[@grid.height + 1, 0]
  end

  def test_supports_neighbors
    expected = [%w[1 2 3], ['4', nil, '6'], %w[7 8 9]]
    assert_equal expected, @grid.neighbors(1, 1)
  end

  def test_supports_neighbors_returning_nil_for_oob_vals
    expected = [[nil, nil, nil], ['1', nil, '3'], %w[4 5 6]]
    assert_equal expected, @grid.neighbors(0, 1)

    expected = [%w[4 5 6], ['7', nil, '9'], [nil, nil, nil]]
    assert_equal expected, @grid.neighbors(2, 1)
  end

  def test_get_all_left_cells
    expected = %w[4 5]
    assert_equal expected, @grid.get_left_from(1, 2)
    expected = %w[4]
    assert_equal expected, @grid.get_left_from(1, 1)
    expected = []
    assert_equal expected, @grid.get_left_from(1, 0)
  end

  def test_get_all_right_cells
    expected = %w[5 6]
    assert_equal expected, @grid.get_right_from(1, 0)
    expected = %w[6]
    assert_equal expected, @grid.get_right_from(1, 1)
    expected = []
    assert_equal expected, @grid.get_right_from(1, 2)
  end

  def test_get_all_above_cells
    expected = %w[2 5]
    assert_equal expected, @grid.get_above_from(2, 1)
    expected = %w[2]
    assert_equal expected, @grid.get_above_from(1, 1)
    expected = []
    assert_equal expected, @grid.get_above_from(0, 1)
  end

  def test_get_all_below_cells
    expected = %w[5 8]
    assert_equal expected, @grid.get_below_from(0, 1)
    expected = %w[8]
    assert_equal expected, @grid.get_below_from(1, 1)
    expected = []
    assert_equal expected, @grid.get_below_from(2, 1)
  end
end
