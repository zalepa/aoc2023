# frozen_string_literal: true

require 'minitest/autorun'
require_relative './lib.rb'

# Unit tests for Day 7
class TestDay7PartA < Minitest::Test
  include Day7A

  def test_parsing_input
    input = "32T3K 765\nT55J5 684\nKK677 28\nKTJJT 220\nQQQJA 483"

    expected = [
      ['32T3K', 765],
      ['T55J5', 684],
      ['KK677', 28],
      ['KTJJT', 220],
      ['QQQJA', 483]
    ]

    assert_equal expected, parse_input(input)
  end

  def test_classify_five_of_a_kind
    assert_equal 6, classify_hand('AAAAA')
    assert_equal 6, classify_hand('33333')
    assert_equal 6, classify_hand('JJJJJ')
    assert_equal 6, classify_hand('TTTTT')
    assert_equal 6, classify_hand('QQQQQ')
  end

  def test_classify_four_of_a_kind
    assert_equal 5, classify_hand('AA8AA')
    assert_equal 5, classify_hand('AAAA3')
    assert_equal 5, classify_hand('3AAAA')
    assert_equal 5, classify_hand('A3AAA')
    assert_equal 5, classify_hand('AA3AA')
    assert_equal 5, classify_hand('AAA3A')
  end

  def test_classify_full_house
    assert_equal 4, classify_hand('23332')
  end

  def test_classify_three_of_a_kind
    assert_equal 3, classify_hand('TTT98')
  end

  def test_classify_two_pair
    assert_equal 2, classify_hand('T3T3J'), 'expected T3T3J to be two pair'
    assert_equal 2, classify_hand('23432'), 'expected 23432 to be two pair'
  end

  def test_classify_pair
    assert_equal 1, classify_hand('A23A4')
    assert_equal 1, classify_hand('Q2KJJ')
  end

  def test_classify_high_card
    assert_equal 0, classify_hand('23456')
  end

  def test_compute_numeric_values_for_hand
    assert_equal [14, 13, 12, 11, 10], convert_hand_to_numeric('AKQJT')
    assert_equal [9, 8, 7, 6, 5], convert_hand_to_numeric('98765')
  end

  def test_compare_hands
    assert_equal 0, compare_hands('33333', '33333')

    assert_equal 1, compare_hands('33332', '2AAAA')
    assert_equal 1, compare_hands('77888', '77788')

    assert_equal -1, compare_hands('2AAAA', '33332')
    assert_equal -1, compare_hands('77788', '77888')
  end

  def test_sorting
    input = "32T3K 765\nT55J5 684\nKK677 28\nKTJJT 220\nQQQJA 483"
    expected = [
      ['QQQJA', 483],
      ['T55J5', 684],
      ['KK677', 28],
      ['KTJJT', 220],
      ['32T3K', 765]
    ]
    assert_equal expected, sort_hands(parse_input(input))
  end
end

class TestDay7PartB < TestDay7PartA
  include Day7B

  def test_classify_five_of_a_kind_with_jokers
    opts = { jokers: true }
    assert_equal 6, classify_hand('AAAAJ', opts) # => AAAAA
  end

  def test_classify_four_of_a_kind_with_jokers
    opts = { jokers: true }
    assert_equal 5, classify_hand('QJJQ2', opts) # => QQQQ2
    assert_equal 5, classify_hand('QJQQ2', opts) # => QQQQ2
    assert_equal 5, classify_hand('JJJ32', opts) # => 33332
    assert_equal 5, classify_hand('AJ8AA', opts) # => AAAA8
    assert_equal 5, classify_hand('23JJ2', opts) # => 22223
    assert_equal 5, classify_hand('T55J5', opts)
  end

  def test_classify_full_house_with_jokers
    opts = { jokers: true }
    assert_equal 4, classify_hand('233J2', opts) # => 23332
    assert_equal 4, classify_hand('AA99J', opts) #=> AAA99 (full house)
  end

  def test_classify_three_of_a_kind_with_jokers
    opts = { jokers: true }
    assert_equal 3, classify_hand('TJJ98', opts) # => TTT98
    assert_equal 3, classify_hand('T3TJ2', opts) # => TTT32
  end
  
  def test_classify_two_pair_with_jokers
    # Is this possible?
  end

  def test_classify_pair_with_jokers
    opts = { jokers: true }
    assert_equal 1, classify_hand('A23J4', opts) # => AA234
  end

  def test_compute_numeric_values_for_hand_with_jokers
    assert_equal [14, 13, 12, 1, 10], convert_hand_to_numeric('AKQJT', jokers: true)
    assert_equal [9, 8, 7, 6, 5], convert_hand_to_numeric('98765', jokers: true)
  end

  def test_compare_hands_with_jokers
    assert_equal -1, compare_hands('JKKK2', 'QQQQ2', jokers: true)
    assert_equal 1, compare_hands('AAAA2', 'AAAAJ', jokers: true)
    assert_equal 0, compare_hands('JJJJJ', 'JJJJJ', jokers: true)
  end

  def test_sorting_with_jokers
    input = "32T3K 765\nT55J5 684\nKK677 28\nKTJJT 220\nQQQJA 483"
    expected = [
      ['KTJJT', 220], # four of kind   
      ['QQQJA', 483], # four of a kind
      ['T55J5', 684], # four of a find T < Q
      ['KK677', 28],  # two pair
      ['32T3K', 765]  # pair
    ]
    assert_equal expected, sort_hands(parse_input(input), jokers: true)
  end
end