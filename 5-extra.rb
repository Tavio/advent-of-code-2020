#!/usr/bin/env ruby

seat_ids = IO.read("input/5.txt").lines.map{|p| p.tr("FBLR","0101").to_i(2)}

# 1:
puts seat_ids.max

# 2:
min_seat_id = seat_ids.min
max_seat_id = seat_ids.max
expected_sum = (max_seat_id - min_seat_id + 1) * (max_seat_id + min_seat_id) / 2
actual_sum = seat_ids.inject(0){|sum,x| sum + x }
puts expected_sum - actual_sum
