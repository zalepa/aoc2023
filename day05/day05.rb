# frozen_string_literal: true

def parse_file(filename)
  raw = File.read(filename)
  seeds = raw.split(/\n/).first
  seeds = seeds.gsub('seeds: ', '').split(' ').map(&:to_i)

  maps = raw.split(/\n/)[1..-1].join(" ").split('map: ').filter { _1.match(/\d/) }
            .map { _1.gsub(/[A-z]|-/, '')}
            .map { _1.strip }
            .map { _1.split(' ').map(&:to_i) }
            .map do |m|
              out = []
              m.each_slice(3) { out << _1 }
              out
            end
  [seeds, maps]
end

class Integer
  def seed_map(d, s, r)
    src = s..(s + r)
    dest = d..(d + r)
    if src.include?(self)
      # src.to_a.index(self)
      idx = self - src.first 
      return dest.first + idx
    end
    

    self
  end
end


almanac = parse_file('./input05.txt')


# PART A
seeds = almanac[0]

# puts "Initial seeds: #{seeds.inspect}\n\n"

almanac[1].each do |stage|
  # puts "# Stage: #{stage.inspect}"
  seeds.each.with_index do |s, i|
    stage.each do |map|
      new_seed = s.seed_map(map[0], map[1], map[2])
      if new_seed != s 
        seeds[i] = new_seed
        break
      end
    end
  end
end

puts "Part A: #{seeds.sort.first}"
