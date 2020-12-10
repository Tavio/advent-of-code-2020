#!/usr/bin/env ruby

adapters = File.readlines('input/10.txt')
                .map(&:to_i)
                .sort

distribution = adapters.reduce([Hash.new(0), 0]) do |(differences, last), adapter|
                          differences[adapter - last] += 1
                          [differences, adapter]
                        end
                       .first
                       .merge({3 => 1}) { |_, v1, v2| v1 + v2 }

# part 1:
puts distribution[1] * distribution[3]

# part 2:

# We walk the array of adapters from left to right, and at each element we check all the possible adapters we could
# have come from to arrive at the current one; then we calculate the total number of combinations of adapters that
# include the current one as the sum of all possible combinations for each of those origin adapters. We start at the
# first adapter in the array, assign it one possible combination (as there is only one way we can arrive at the
# seat adapter when going from left to right), and carry on the computation as previously described. We use a
# supporting array for this called combinations, which will contain the correct answer in its last position at the end
# of the computation.
#
# As an example, for this array of adapters:
#
# [0, 1, 2, 3, 5, 8]
#
# This is what the array of possible combinations would looks like:
#
# [1, 1, 2, 4, 6, 6]

# add seat adapter to array, which was not originally present in the input
adapters = [0] + adapters
# initialize supporting array, it needs one position per adapter
combinations = adapters.map { |_| 0 }
# total number of ways in which we can arrive at the seat adapter is one
combinations[0] = 1

# now we build the supporting table in dynamic programming fashion
for i in 1..(combinations.size - 1)
  # c is the number of ways we can arrive at the current adapter
  c = 0
  # for each adapter 3, 2, and 1 positions before the current one, add their number of combinations to c if they can
  # be reached by this adapter (a previous adapter can be reached by the current one if its joltage is at a distance
  # of 3 or less from this one's):
  c += combinations[i - 3] if i >= 3 && adapters[i] - adapters[i - 3] <= 3
  c += combinations[i - 2] if i >= 2 && adapters[i] - adapters[i - 2] <= 3
  c += combinations[i - 1] if i >= 1 && adapters[i] - adapters[i - 1] <= 3
  combinations[i] = c
end

puts combinations.last
