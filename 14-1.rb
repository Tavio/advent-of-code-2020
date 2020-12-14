#!/usr/bin/env ruby

def pretty_print(masks)
  puts masks.map { |x| x.map { |y| y.to_s(2) } }.inspect
end

def parse_mask(mask)
  masks = [0,0]
  mask.split('').reverse.each_with_index do |c, i|
    case c
    when "0"
      masks[0] = masks[0] | 2 ** i
    when "1"
      masks[1] = masks[1] | 2 ** i
    end
  end
  masks
end

def apply_masks(value, masks)
  zeroes_mask, ones_mask = masks
  value = value | ones_mask
  value = value & (~zeroes_mask)
  value
end

def run(input)
  masks = [0,0]
  memory = []
  File.readlines(input, chomp: true).each do |line|
    if (matches = line.match(/mask = (.*)/))
      masks = parse_mask(matches[1])
    elsif (matches = line.match(/mem\[([^]]+)\] = (.*)/))
      mem, value = matches[1..2].map(&:to_i)
      memory[mem] = apply_masks(value, masks)
    end
  end
  memory
end

memory = run('input/14.txt')
puts memory.compact.reduce(:+)
