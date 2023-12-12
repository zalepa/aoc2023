require_relative './lib'

puts "Running Part A..."

class PartA
  include Day7A
end

input = File.read('./input07.txt')
p = PartA.new
sorted_hands = p.sort_hands(p.parse_input(input))
score = 0 
sorted_hands.reverse.each.with_index do |h, i|
  score += h[1] * (i + 1)
end

puts "Part A: #{score}"


puts "Running Part B..."

class PartB
  include Day7B
end

input = File.read('./input07.txt')
p = PartB.new
sorted_hands = p.sort_hands(p.parse_input(input), jokers: true)
score = 0 
sorted_hands.reverse.each { puts _1.inspect }
sorted_hands.reverse.each.with_index do |h, i|
  score += h[1] * (i + 1)
end

puts "Part A: #{score}"