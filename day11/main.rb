# frozen_string_literal: true

require_relative './lib'

raw = File.read('./input.txt')
space = Space.new(raw)
space.expand
puts "Part A: #{space.total_distances}"

raw = File.read('./input.txt')
space = Space.new(raw)
space.expand(sim: true, amount: 1_000_000)
puts "Part B: #{space.total_distances(sim: true)}"
