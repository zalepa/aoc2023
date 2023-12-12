# frozen_string_literal: true

# Day 7 implementation
module Day7A
  # Parse an input string into a 2D array of [hand, bid] pairs
  def parse_input(str)
    str.split(/\n/)
      .map { _1.split(' ') }
      .map { [_1[0], _1[1].to_i]}
  end

  # Classify a five-character hand string
  def classify_straight(hand)
    valid_card = /([AKQJT98765432])/
    return 6 if hand.match(/#{valid_card}\1{4}/)

    hand = hand.split('').sort.join
    return 5 if hand.match(/#{valid_card}\1{3}/)
    return 4 if hand.match(/#{valid_card}\1#{valid_card}\2\2/) || hand.match(/#{valid_card}\1\1#{valid_card}\2/)
    return 3 if hand.match(/#{valid_card}\1\1/)
    return 2 if hand.match(/#{valid_card}\1.*#{valid_card}\2/)
    return 1 if hand.match(/#{valid_card}\1/)

    0
  end

  def classify_with_jokers(hand)
    return classify_straight(hand) unless hand.match(/J/) # no jokers, no problem

    return 1 if hand.gsub(/J/, '').chars.uniq.count == 4 # two pair at best
    return 6 if hand.gsub(/J/, '').chars.uniq.count == 1 # five of a kind

    hand_without_jokers = hand.chars.reject { _1 == 'J' }.join
    number_of_jokers = hand.length - hand_without_jokers.length
    permutations = 'AKQT98765432J'.split('').repeated_permutation(number_of_jokers)

    high_score = 0

    permutations.each do |p|
      candidate_hand = hand_without_jokers + p.join
      candidate_score = classify_straight(candidate_hand)
      if candidate_score == 6
        high_score = candidate_score
        break
      elsif candidate_score > high_score
        high_score = candidate_score
      end
    end

    high_score
  end

  def classify_hand(hand, opts = {})
    opts[:jokers] ? classify_with_jokers(hand) : classify_straight(hand)
  end

  # Compare two hands and return the winner
  def compare_hands(a, b, opts = {})
    return 0 if a == b

    a_numeric = convert_hand_to_numeric(a, opts)
    b_numeric = convert_hand_to_numeric(b, opts)
    a_numeric.each.with_index do |a_val, idx|
      b_val = b_numeric[idx]
      next if a_val == b_val
      return 1 if a_val > b_val
      return -1 if b_val > a_val
    end
  end

  

  # Convert a string hand to numeric values
  def convert_hand_to_numeric(hand, opts = {})
    return convert_hand_to_numeric_with_jokers(hand) if opts[:jokers]

    hand.chars.map do |c|
      val = case c
        when 'A'
          14
        when 'K'
          13
        when 'Q'
          12
        when 'J'
          11
        when 'T'
          10
        else
          c.to_i
      end
      val
    end
  end

  # Convert a string hand to numeric values (with Jokers)
  def convert_hand_to_numeric_with_jokers(hand)
    hand.chars.map do |c|
      val = case c
        when 'A'
          14
        when 'K'
          13
        when 'Q'
          12
        when 'J'
          1
        when 'T'
          10
        else
          c.to_i
      end
      val
    end
  end

  def sort_hands(hands, opts = {})
    hands.sort do |a, b|
      a_class = classify_hand(a.first, opts)
      b_class = classify_hand(b.first, opts)
      if a_class == b_class
        compare_hands(a.first, b.first)
      else
        a_class <=> b_class
      end
    end.reverse
  end
end

module Day7B
  include Day7A
end