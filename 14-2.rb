#!/usr/bin/env ruby

def parse_mask(mask)
  masks = [0, []]
  mask.split('').reverse.each_with_index do |c, i|
    case c
    when "1"
      masks[0] = masks[0] | (2 ** i)
    when "X"
      masks[1] << (2 ** i)
    end
  end
  masks
end

def apply_floats(masks, result)
  # At each step, take the next mask and use it to generate two new values for each value in the result array
  return result if masks.empty? # return if no more masks to apply

  mask = masks[0]

  res = result.reduce([]) do |rs, r|
    rs + [
      r | mask, # variation with floating bit set to 1
      r & ~mask # variation with floating bit set to 0
    ]
  end

  apply_floats(masks.drop(1), res) # recurse with one less mask
end

def apply_masks(address, masks)
  ones_mask, float_masks = masks
  address |= ones_mask # ones are set by oring
  addresses = apply_floats(float_masks, [address]) # expand value into its floating variations
  addresses
end

def run(input)
  # The first element in masks is the ones mask, where every on bit means the bit on the same position in the memory address has to be set to one.
  # The second element is an array of float masks. Each float mask has a one in only one of the bits, and the rest are 0. The bit that is on represents
  # in which position of the memory address we need to generate the floating bits.
  # We don't bother building a zeroes mask since it wouldn't change the memory address
  masks = [0, []]
  memory = {}
  File.readlines(input, chomp: true).each do |line|
    if (matches = line.match(/mask = (.*)/))
      # command is to change the mask
      masks = parse_mask(matches[1])
    elsif (matches = line.match(/mem\[([^\]]+)\] = (.*)/))
      # command is to set a value in memory
      mem, value = matches[1..2].map(&:to_i)
      # expand memory address into its floating variations and set each resulting address to the same value
      mem_addresses = apply_masks(mem, masks)
      mem_addresses.each do |m|
        memory[m] = value
      end
    end
  end
  memory
end

memory = run('input/14.txt')
puts memory.values.reduce(:+)
