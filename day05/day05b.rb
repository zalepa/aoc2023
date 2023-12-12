require 'minitest/autorun'

def range_filter(input_range, source_map, destination_map)
  return [destination_map] if input_range == source_map
  return [input_range] if input_range.first > source_map.last || input_range.last < source_map.first

  if input_range.cover?(source_map)
    first = input_range.first..(source_map.first-1)
    second = destination_map
    third = (first.count + second.count + 1)..input_range.last
    res = [first, second, third]
  elsif source_map.cover?(input_range)
    idx_start_offset = input_range.first - source_map.first
    idx_stop_offset  = input_range.last - source_map.last
    res = [(destination_map.first + idx_start_offset)..(destination_map.last + idx_stop_offset)]
  elsif input_range.first < source_map.first && input_range.last > source_map.first
    idx_start_offset = source_map.first - input_range.first - 1
    res = []
    res << (input_range.first..(input_range.first + idx_start_offset))
    idx_stop_offset  = ((input_range.first + idx_start_offset + 1)..input_range.last).count
    res << (destination_map.first..(destination_map.first + idx_start_offset + 1))
  elsif input_range.first < source_map.last && input_range.last > source_map.last
    overlap_size = (input_range.first..source_map.last).count
    res = []
    res << (destination_map.first..(destination_map.first + overlap_size - 1))
    res << ((input_range.first + overlap_size)..input_range.last)
  end

  return res
end

# Test range operation
class RangeOperationTest < Minitest::Test
  def test_perfect_overlap
    res = range_filter(1..3, 1..3, 4..6)
    assert_equal [4..6], res
  end

  def test_no_overlap
    res = range_filter(1..3, 4..6, 4..6)
    assert_equal [1..3], res
  end

  def test_input_subsumes_source_map
    res = range_filter(2..10, 3..5, 4..6)
    assert_equal [2..2, 4..6, 6..10], res
  end 

  def test_source_map_subsumes_input
    res = range_filter(2..4, 1..10, 11..20)
    assert_equal [12..14], res
  end

  def test_input_overlaps_partially_left_side_of_source
    res = range_filter(3..5, 4..8, 509..513)
    assert_equal [3..3, 509..510], res
  end

  def test_input_overlaps_partially_right_side_of_source
    res = range_filter(7..10, 4..8, 509..514)
    assert_equal [509..510, 9..10], res
  end
end

