#!/usr/bin/env ruby

numbers = [0,20,7,16,1,18,15]
indexes = numbers[0..-2].each_with_index.reduce({}) do |idx, (num, i)|
  idx[num] = i
  idx
end

i = numbers.size - 1
while i < 29999999 do
  new_number = indexes[numbers.last].nil? ? 0 : i - indexes[numbers.last]
  indexes[numbers.last] = i
  numbers << new_number
  i += 1
end

puts numbers.last
