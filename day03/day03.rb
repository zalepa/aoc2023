# A grid class
class Grid
  attr_reader :cells

  def initialize(str)
    @height = str.split(/\n/).count
    @width  = str.split(/\n/)[0].length

    @cells = Array.new(@height)
    str.split(/\n/).each.with_index do |r, i|
      @cells[i] = []
      r.split('').each.with_index do |c, j|
        @cells[i][j] = c
      end
    end
  end

  def each_cell
    @cells.each.with_index do |row, i|
      row.each.with_index do |cell, j|
        yield cell, i, j
      end
    end
  end

  def [](col, row)
    return nil if col.negative?
    return nil if col > @width - 1
    return nil if row > @height - 1
    return nil if row.negative?

    @cells[col][row]
  end

  def neighbors(x, y)
    [
      [self[x - 1, y - 1], self[x - 1, y], self[x - 1, y + 1]],
      [self[x, y - 1], nil, self[x, y + 1]],
      [self[x + 1, y - 1], self[x + 1, y], self[x + 1, y + 1]]
    ]
  end
end

file = File.read('./input03.txt')

g = Grid.new(file)

# PART A

found = []

g.each_cell do |cell, x, y|
  neighbors = g.neighbors(x, y).flatten
  num = [cell]

  if cell.match(/[0-9]/) && (g[x, y +1].nil? || !g[x, y + 1].match(/\d/))
    # we found the last digit of a number
    dy = 1
    while !g[x, y - dy].nil? && g[x, y - dy].match(/\d/)
      # walk back, collecting neighbors
      neighbors += g.neighbors(x, y - dy).flatten
      num << g[x, y-dy]
      dy += 1
    end
    # puts num.join('').reverse.to_i
    unless neighbors.compact.reject { _1.match(/\d/) || _1.match(/\./) }.uniq.empty?
      found << num.join('').reverse.to_i
    end
  end
  
end

print 'Part A: ', found.inject(&:+), "\n"


# PART B

def expand(row, x, y, g)
  return row if row.match(/^\d\d\d$/) # row is full number
  expanded_row = row
  
  if row.match(/^\d\D\D$/) || row.match(/^\d\d\D$/)
    i = 2
    until g[x, y - i].nil? || g[x, y - i].match(/\D/)
      expanded_row = g[x, y - i] + expanded_row
      i += 1
    end
  end

  if row.match(/^\D\d\d$/) || row.match(/^\D\D\d$/)
    i = 2
    until g[x, y + i].nil? || g[x, y + i].match(/\D/)
      expanded_row = expanded_row + g[x, y + i]
      i += 1
    end
  end

  expanded_row
end

answer = 0

g.each_cell do |cell, x, y|
  next if cell != '*'

  neighbors = g.neighbors(x, y)
  
  adjacent_numbers = []

  adjacent_count = 0

  if !neighbors[1][0].nil? && neighbors[1][0].match(/\d/) # left
    adjacent_count += 1 
    adjacent_numbers << "#{g[x, y - 3]}#{g[x, y - 2]}#{g[x, y - 1]}".gsub(/\D/, '').to_i
  end
  
  if !neighbors[1][2].nil? && neighbors[1][2].match(/\d/) # right
    adjacent_count += 1 
    adjacent_numbers << "#{g[x, y + 1]}#{g[x, y + 2]}#{g[x, y + 3]}".gsub(/\D/, '').to_i
  end

  top_row = neighbors[0].join('')
  bottom_row = neighbors[2].join('')

  if top_row.match(/^\d\D\d$/)
    adjacent_count +=2 
    adjacent_numbers << "#{g[x - 1, y - 3]}#{g[x - 1, y - 2]}#{g[x - 1, y - 1]}".gsub(/\D/, '').to_i
    adjacent_numbers << "#{g[x - 1, y + 1]}#{g[x - 1, y + 2]}#{g[x - 1, y + 3]}".gsub(/\D/, '').to_i
  elsif top_row.match(/\d/)
    adjacent_count += 1
    expanded_top_row = expand(top_row, x - 1, y, g)
    adjacent_numbers.concat(expanded_top_row.scan(/\d*/).reject { _1.empty? }.map(&:to_i))
  end

  if bottom_row.match(/^\d\D\d$/)
    adjacent_count +=2 
    adjacent_numbers << "#{g[x + 1, y - 3]}#{g[x + 1, y - 2]}#{g[x + 1, y - 1]}".gsub(/\D/, '').to_i
    adjacent_numbers << "#{g[x + 1, y + 1]}#{g[x + 1, y + 2]}#{g[x + 1, y + 3]}".gsub(/\D/, '').to_i
  elsif bottom_row.match(/\d/)
    adjacent_count += 1
    expanded_bottom_row = expand(bottom_row, x + 1, y, g)
    adjacent_numbers.concat(expanded_bottom_row.scan(/\d*/).reject { _1.empty? }.map(&:to_i))
  end

  if adjacent_count > 1
    answer += adjacent_numbers.inject(&:*)
  end

end

print 'Part B: ', answer, "\n"