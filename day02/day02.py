import re

f = open('input02.txt', 'r')
lines = f.read().splitlines()

def parse_color(name, s):
  """
  Parses a pull string (e.g., 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green)
  and returns a list of tuples [("blue", 3), ("red", 4)... etc.]
  """
  out = []
  matches = re.findall(f"([0-9]+) {name}", s)
  if matches:
    for m in matches:
      out.append((name, int(m)))
  return out

def parse_bag_pull(s):
  pulls = []
  pulls += parse_color('blue', s)
  pulls += parse_color('green', s)
  pulls += parse_color('red', s)
  return pulls

def valid_turn(turn):
  for t in turn:
    if t[0] == 'red' and t[1] > 12:
      return False
    if t[0] == 'green' and t[1] > 13:
      return False
    if t[0] == 'blue' and t[1] > 14:
      return False
  return True


sum = 0

for line in lines:
  game_id, pulls = line.split(': ')  
  game_id = int(re.search(r"[0-9]+", game_id).group())
  pulls = [valid_turn(parse_bag_pull(pull)) for pull in pulls.split('; ')]
  if not False in pulls:
    sum += game_id

print('Part A:', sum)

#  PART B

f.seek(0)

def get_maxes(pulls):
  maxes = {"blue": 0, "red": 0, "green": 0 }
  for pull in pulls:
    for color in pull:
      if color[0] == 'blue' and color[1] > maxes[color[0]]:
        maxes[color[0]] = color[1]
      if color[0] == 'green' and color[1] > maxes[color[0]]:
        maxes[color[0]] = color[1]
      if color[0] == 'red' and color[1] > maxes[color[0]]:
        maxes[color[0]] = color[1]

  return maxes

sum = 0 
for line in lines:
  game_id, pulls = line.split(': ')  
  game_id = int(re.search(r"[0-9]+", game_id).group())
  
  pulls = [parse_bag_pull(pull) for pull in pulls.split('; ')]

  maxes = get_maxes(pulls)

  power = maxes['blue'] * maxes['green'] * maxes['red']
  sum += power

print('Part B', sum)
