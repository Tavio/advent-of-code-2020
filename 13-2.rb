#!/usr/bin/env ruby

_, bus_times = File.readlines('input/13.txt', chomp: true)

# We build an array of pairs (a,b) where each pair represents an equation of the form x % a = b, where
# x is the timestamp we are looking for. For the sample input "7,13,x,x,59,x,31,19" this array will be:
# [[59, 55], [31, 25], [19, 12], [13, 12], [7, 0]]
# Note that we sort the array by descending value of a in order to optimize the next step.

equations = bus_times.split(',')
              .each_with_index.map do |t, i|
                if t == 'x'
                  nil
                else
                  ti = t.to_i
                  [ti, (ti - i) % ti]
                end
              end
              .compact
              .sort { |(mod1,_),(mod2,_)| mod2 <=> mod1 }

# Next, we find the solution for the system of equations via search by sieving (which only works because
# the bus ids are pairwise coprime, that is, for every pair of bus ids, their only common divisor is 1):
# https://en.wikipedia.org/wiki/Chinese_remainder_theorem#Search_by_sieving

res = equations.reduce do |(mod1, rem1),(mod2, rem2)|
  x = rem1
  while x % mod2 != rem2 do
    x += mod1
  end
  [mod1 * mod2, x]
end

puts res.last
