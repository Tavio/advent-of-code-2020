#!/usr/bin/env ruby

departure_time, bus_times = File.readlines('input/13.txt', chomp: true)
departure_time = departure_time.to_i
bus_times = bus_times.split(',')
              .reject { |t| t == 'x'}
              .map(&:to_i)
found = nil
possible_departure = departure_time
while !found do
  found = bus_times.find { |t| possible_departure % t == 0 }
  possible_departure += 1
end

puts found * (possible_departure - departure_time - 1)
