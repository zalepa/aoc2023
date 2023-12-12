# frozen_string_literal: true

input = File.readlines('./input01.txt')

# Part A
lines = input
        .map { _1.scan(/\d/) }
        .map { (_1[0] + _1[-1]).to_i }

puts "Part A: #{lines.inject(&:+)}"

# Part B

def replace_digit_names(str)
  str = str.gsub('one',   'one1one')
  str = str.gsub('two',   'two2two')
  str = str.gsub('three', 'three3three')
  str = str.gsub('four',  'four4four')
  str = str.gsub('five',  'five5five')
  str = str.gsub('six',   'six6six')
  str = str.gsub('seven', 'seven7seven')
  str = str.gsub('eight', 'eight8eight')
  str.gsub('nine', 'nine9nine')
end

lines = input
        .map { replace_digit_names(_1) }
        .map { _1.gsub(/\D/, '')}
        .map { _1.scan(/\d/) }
        .map { (_1[0] + _1[-1]).to_i }

puts "Part B: #{lines.inject(&:+)}"
