#!/usr/bin/env ruby

require 'set'

def group_intersection_size(group)
  group.map { |answers| answers.split('').to_set }
       .reduce(:&)
       .size
end

puts IO.read("input/6.txt")
       .split("\n\n")
       .map { |line| line.split("\n")}
       .map { |group| group_intersection_size(group) }
       .reduce(:+)
