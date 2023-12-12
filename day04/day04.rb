# sample = <<~SAMPLE
#   Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
#   Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
#   Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
#   Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
#   Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
#   Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
# SAMPLE
# lines = sample.split(/\n/)
lines = File.readlines('./input04.txt')

# prep an input line for processing.
def prep(line)
  number = line.match(/Card\s*(\d*)/)[1].to_i
  line = line.gsub(/^Card\s*\d*:\s*/, '')
  want, have = line.split(' | ')
  have = have.split(' ').map(&:to_i)
  want = want.split(' ').map(&:to_i)
  [number, have, want]
end

def matching_numbers(have, winning)
  have.intersection(winning)
end

def double(amount, score)
  amount.times { score *= 2 }
  score
end

# Part A
scores = lines.map.with_index do |line, i|
  _, have, winning = prep(line)
  matches = matching_numbers(have, winning)
  matches.empty? ? 0 : double(matches.length - 1, 1)
end

puts "Part A: #{scores.inject(&:+)}"

# Part B
amounts = Array.new(lines.count, 0)

lines.each do |line|
  number, have, winning = prep(line)
  amounts[number - 1] += 1
  matching = matching_numbers(have, winning)
  amounts[number - 1].times do
    (number + 1).upto(number + matching.count) do |i|
      amounts[i - 1] += 1
    end
  end

end

puts "Part B: #{amounts.inject(&:+)}"