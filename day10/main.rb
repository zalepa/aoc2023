require_relative './lib'

raw = File.read('./input.txt')
grid = Maze.new(raw)
grid.walk_pipe!
# pp ("Part A:" pipe.length / 2) + 1

pp "Before in-filling"
grid.cells.each { puts _1.join() }

grid.infill
  
pp "After in-filling"
grid.cells.each { puts _1.join() }