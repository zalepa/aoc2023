# frozen_string_literal: true

module Day8
  def parse_input(str)
    rows = str.split(/\n/)
    directions = rows[0].split('')
    map = {}
    rows[2..].each do |r|
      node, connections = r.split(' = ')
      map[node] = connections.gsub(/\(|\)/, '').split(', ')
    end

    [directions, map]
  end

  def get_next_node(map, node, direction)
    direction == 'L' ? map[node].first : map[node].last
  end

  def move(map, start, directions, end_condition=nil)
    i = 0
    end_condition = /ZZZ/ if end_condition.nil?
    current_node = start
    until current_node.match(end_condition)
      directions.each do |dir|
        current_node = get_next_node(map, current_node, dir)
        i += 1
        break if current_node.match(end_condition)
      end
    end
    [current_node, i]
  end

  def ghost_move(map, directions)
    starts = map.keys.filter { _1.match /A$/ }
    starts.map! { move(map, _1, directions, /Z$/)}.map! { _1.last }.inject(1) { |lcm, number| lcm.lcm(number) }
  end

end