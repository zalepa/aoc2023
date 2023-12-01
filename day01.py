import re

f = open('inputs/input01.txt', 'r')
lines = f.read().splitlines()                       # read lines
lines = [re.sub(r'\D', '', line) for line in lines] # strip non-numbers
lines = [line[0] + line[-1] for line in lines]      # get first and last
lines = [int(line) for line in lines]               # convert to integer
print("Part A:", sum(lines))

def replace_digit_names(lines):
  """
  Isn't this a beautifully elegant function?
  """
  lines = [line.replace('one',   'one1one')     for line in lines]
  lines = [line.replace('two',   'two2two')     for line in lines]
  lines = [line.replace('three', 'three3three') for line in lines]
  lines = [line.replace('four',  'four4four')   for line in lines]
  lines = [line.replace('five',  'five5five')   for line in lines]
  lines = [line.replace('six',   'six6six')     for line in lines]
  lines = [line.replace('seven', 'seven7seven') for line in lines]
  lines = [line.replace('eight', 'eight8eight') for line in lines]
  lines = [line.replace('nine',  'nine9nine')   for line in lines]
  return lines


f.seek(0) # go back to first line
lines = f.read().splitlines()                       # read lines
lines = replace_digit_names(lines)                  # replace digit names
lines = [re.sub(r'\D', '', line) for line in lines] # strip non-numbers
lines = [line[0] + line[-1] for line in lines]      # get first and last
lines = [int(line) for line in lines]               # convert to integer

print("Part B:", sum(lines))