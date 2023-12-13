# frozen_string_literal: true

# A line of springs
class Line
  attr_reader :springs, :ranges

  def initialize(str, opts = {})
    @springs, @ranges = str.split(/\s/)
    @ranges = @ranges.split(',').map(&:to_i)
    @unknowns = @springs.split('').filter { _1 == '?' }.count
    unfold if opts[:unfold]
  end

  def possible_permutations
    2 ** @unknowns
  end

  def permutations
    candidates = []
    0.upto(possible_permutations - 1) do |i|
      candidate = i.to_s(2).rjust(@unknowns, '0').gsub('1', '.').gsub('0', '#').split('')
      new_springs = ''
      @springs.each_char do |c|
        char = (c == '?' ? candidate.pop : c)
        new_springs += char
      end
      l = Line.new("#{new_springs} #{@ranges.join(',')}")
      candidates << l if l.valid?
    end
    candidates
  end

  def valid?
    @springs.split('.').reject(&:empty?).map(&:length) == @ranges
  end

  def unfold
    @springs = ("#{@springs}?" * 5).chop
    @ranges *= 5
    @unknowns = @springs.split('').filter { _1 == '?' }.count
  end
end
