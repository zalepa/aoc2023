# frozen_string_literal: true

require './lib'

# raw = File.readlines('input.txt')

# lines = raw.map { Line.new _1 }.map { _1.permutations.count }

# pp "Part A: #{lines.inject(&:+)}"

raw = File.readlines('sample.txt')

lines = raw.map { Line.new(_1, unfold: true) }.map { _1.permutations.count }

pp lines
# pp "Part A: #{lines.inject(&:+)}"