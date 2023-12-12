# frozen_string_literal: true

require 'minitest/autorun'
require_relative './lib'

class TestPartA < Minitest::Test
  include Day8

  def setup
    @raw = File.read('../inputs/sample08.txt')
    # RL

    # AAA = (BBB, CCC)
    # BBB = (DDD, EEE)
    # CCC = (ZZZ, GGG)
    # DDD = (DDD, DDD)
    # EEE = (EEE, EEE)
    # GGG = (GGG, GGG)
    # ZZZ = (ZZZ, ZZZ)
    @parsed = parse_input(@raw)
    @directions = @parsed.first
    @map = @parsed.last
  end

  def test_parsing_input
    assert @parsed.count == 2

    assert_equal Array, @parsed.first.class
    assert_equal Hash, @parsed.last.class
  end

  def test_movement
    assert_equal 'BBB', get_next_node(@map, 'AAA', 'L')
    assert_equal 'CCC', get_next_node(@map, 'AAA', 'R')
  end

  def test_scripted_movement
    # assert_equal ['ZZZ', 2], move(@map, 'AAA', @directions)
  end

  def test_scripted_movement_with_wraparound
    directions = %w[L L R]
    map = {
      'AAA' => %w[BBB BBB],
      'BBB' => %w[AAA ZZZ],
      'ZZZ' => %w[ZZZ ZZZ]
    }

    assert_equal ['ZZZ', 6], move(map, 'AAA', directions)
  end

  def test_ghost_move
    directions = %w[L R]
    map = {
      '11A' => %w[11B XXX],
      '11B' => %w[XXX 11Z],
      '11Z' => %w[11B XXX],
      '22A' => %w[22B XXX],
      '22B' => %w[22C 22C],
      '22C' => %w[22Z 22Z],
      '22Z' => %w[22B 22B],
      'XXX' => %w[XXX XXX]
    }
    assert_equal 6, ghost_move(map, directions)
  end
end

