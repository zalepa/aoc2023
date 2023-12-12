require_relative './lib'

class Runner
  include Day8
end

raw = File.read('./input.txt')
runner = Runner.new
parsed = runner.parse_input(raw)

last, steps = runner.move(parsed.last, 'AAA', parsed.first)

puts "Part A: #{steps}"

ghost_steps = runner.ghost_move(parsed.last, parsed.first)
puts "Part B: #{ghost_steps}"