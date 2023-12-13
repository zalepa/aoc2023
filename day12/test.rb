# frozen_string_literal: true

require_relative '../test_helper'
require_relative './lib'

describe 'Line' do
  it 'parses a line' do
    l = Line.new '.????#?.??? 1,3,3'
    assert l.springs == '.????#?.???'
    assert l.ranges == [1, 3, 3]

    l = Line.new '#.#.### 1,1,3'
    assert l.springs == '#.#.###'
    assert l.ranges == [1, 1, 3]
  end

  it 'can determine the number of possible permutations' do
    l = Line.new '???.### 1,1,3'
    assert_equal 8, l.possible_permutations
  end

  it 'can identify valid spring lists' do
    l = Line.new '#.#.### 1,1,3'
    assert l.valid?

    l = Line.new '#.#.### 1,1,4'
    refute l.valid?
  end

  it 'can identify only valid permutations' do
    l = Line.new '???.### 1,1,3'
    assert_equal 1, l.permutations.count
    l = Line.new '.??..??...?##. 1,1,3'
    assert_equal 4, l.permutations.count
  end

  it 'can support unfolding lines' do
    l = Line.new('.# 1')
    l.unfold
    assert_equal '.#?.#?.#?.#?.#', l.springs
    assert_equal [1,1,1,1,1], l.ranges

    l = Line.new('.# 1', unfold: true)
    assert_equal '.#?.#?.#?.#?.#', l.springs
    assert_equal [1,1,1,1,1], l.ranges
  end
end
