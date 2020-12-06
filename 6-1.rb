#!/usr/bin/env ruby

require 'set'

def count_unique_answers(group)
  group.map { |answers| answers.split('').to_set }
       .reduce(:merge)
       .size
end

puts IO.read("input/6.txt")
       .split("\n\n")
       .map { |line| line.split("\n")}
       .map { |group| count_unique_answers(group) }
       .reduce(:+)
