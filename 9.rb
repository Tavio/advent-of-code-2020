#!/usr/bin/env ruby

PREAMBLE_SIZE = 25
numbers = File.readlines('input/9.txt').map(&:to_i)

def valid?(i, numbers)
  numbers[(i - PREAMBLE_SIZE)..(i - 1)].combination(2).find { |(x, y)| x + y == numbers[i]}
end

def find_invalid(numbers)
  invalid = nil

  for i in (PREAMBLE_SIZE)..(numbers.size - 1) do
    if !valid?(i, numbers)
      invalid = numbers[i]
      break
    end
  end

  invalid
end

def find_contiguous_set(numbers, target)
  # start with a set of size two at the end of the array of numbers
  set_start = numbers.size - 2
  set_end = numbers.size - 1
  # precalculated set sum that can be updated in constant time in loop below
  set_sum = numbers[set_start] + numbers[set_end]
  loop do
    if set_sum < target || set_start == set_end
      # if sum is less than the target, or our current set size is 1, increase set to the left
      set_start -= 1
      set_sum += numbers[set_start]
    elsif set_sum > target
      # if the sum is already greater than the target, shrink set from the right
      set_sum -= numbers[set_end]
      set_end -= 1
    else
      # set found!
      set = numbers[set_start..set_end]
      return set.min + set.max
    end
  end
end

invalid_number = find_invalid(numbers)

# Part 1:
puts invalid_number

# Part 2:
puts find_contiguous_set(numbers, invalid_number)
