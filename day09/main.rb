# frozen_string_literal: true

def compute_tiers(row)
  tiers = [row]
  active_tier = row

  until active_tier.count.positive? && active_tier.reject(&:zero?).empty?
    next_tier = []
    active_tier.each_cons(2) { next_tier << (_1.last - _1.first) }
    tiers << next_tier
    active_tier = next_tier
  end

  tiers
end

def extrapolate(tiers)
  tiers.map { _1 << 0 }
  reversed_tiers = tiers.reverse
  1.upto(reversed_tiers.count - 1) do |i|
    tier = reversed_tiers[i]
    tier[-1] = tier[-2] + reversed_tiers[i - 1][-1]
  end
  tiers
end

# PART A
predictions = File.readlines('./input.txt').map do |line|
  line = line.split(' ').map(&:to_i)
  tiers = compute_tiers(line)
  extrapolate(tiers).first[-1]
end

puts "Part A: #{predictions.inject(&:+)}"

# PART B
predictions = File.readlines('./input.txt').map do |line|
  line = line.split(' ').map(&:to_i)
  tiers = compute_tiers(line.reverse)
  extrapolate(tiers).first[-1]
end
puts "Part B: #{predictions.inject(&:+)}"