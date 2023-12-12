def predict_wins(time, record_distance)
  wins = []
  0.upto(time) do |milliseconds_held|
    speed = milliseconds_held # mm/ms
    time_remaining = time - milliseconds_held # ms 
    distance = time_remaining * speed
    wins << milliseconds_held if distance > record_distance
  end
  wins #.reject { _1 <= time }
end

def parse_input(str)
  time, distance = str.split("\n")

  time = time.split(/Time:\s*/)[1].split(/\s/).map(&:to_i).reject { _1.zero? }
  distance = distance.split(/Distance:\s*/)[1].split(/\s/).map(&:to_i).reject { _1.zero? }
  
  pairs = time.map.with_index do |t, i|
    [t, distance[i]]
  end
end

puzzle_input = <<~SAMPLE
Time:      7  15   30
Distance:  9  40  200
SAMPLE

puzzle_input = File.read('./input06.txt')

time_distance_pairs = parse_input(puzzle_input)

# Part A
results = time_distance_pairs.map do |pair|
  predict_wins(pair.first, pair.last).count
end

puts "Part A: #{results.inject(&:*)}"

# Part B
def parse_kerned_input(str)
  time, distance = str.split("\n")

  time = time.split(/Time:\s*/)[1].split(/\s/).join
  distance = distance.split(/Distance:\s*/)[1].split(/\s/).join
  
  [time, distance].map(&:to_i)
end

time_distance_pair = parse_kerned_input(puzzle_input)

puts "Part B: #{predict_wins(time_distance_pair.first, time_distance_pair.last).count}"