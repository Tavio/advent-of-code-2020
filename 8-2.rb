#!/usr/bin/env ruby

class Instruction
  attr_accessor :name, :number, :visited

  def initialize(name, number)
    @name = name
    @number = number
    @visited = false
  end

  def visit
    @visited = true
    self
  end

  def reset
    @visited = false
    self
  end

  def run(i, acc)
    raise 'implemented by subclass'
  end

  def flip
    raise 'implemented by subclass'
  end
end

class Nop < Instruction
  def initialize(number)
    super("nop", number)
  end

  def run(i, acc)
    [i + 1, acc]
  end

  def flip
    Jmp.new(number)
  end
end

class Jmp < Instruction
  def initialize(number)
    super("nop", number)
  end

  def run(i, acc)
    [i + number, acc]
  end

  def flip
    Nop.new(number)
  end
end

class Acc < Instruction
  def initialize(number)
    super("nop", number)
  end

  def run(i, acc)
    [i + 1, acc + number]
  end

  def flip
    self
  end
end

def terminates?(instructions)
  acc = 0
  i = 0
  loop do
    instruction = instructions[i]
    break if i >= instructions.size || instruction.visited

    instructions[i] = instruction.visit
    i, acc = instruction.run(i, acc)
  end
  # returns boolean representing termination and acc. Termination happens if we tried to execute below the last line.
  [i >= instructions.size, acc]
end

def flip_next_instruction(instructions, last_flipped_index)
  # unflip last instruction we flipped before; -1 means we haven't flipped any instruction yet
  instructions[last_flipped_index] = instructions[last_flipped_index].flip if last_flipped_index != -1

  # starting one line after the last instruction we attempted to flip, flip the next eligible one
  for i in (last_flipped_index + 1)..(instructions.size - 1)
    if instructions[i].name == "nop" || instructions[i].name == "jmp"
      instructions[i] = instructions[i].flip
      break
    end
  end
  #return index of flipped instruction
  i
end

def parse_instructions(input)
  File.readlines(input).map do |line|
    name, number = line.split(' ')
    sign = number[0]
    number = number[1..-1].to_i
    number = sign == '+' ? number : -1 * number
    case name
    when "nop"
      Nop.new(number)
    when "jmp"
      Jmp.new(number)
    when "acc"
      Acc.new(number)
    end
  end
end

instructions = parse_instructions('input/8.txt')

acc = 0
last_flipped_index = -1 # index of last instruction we tried to flip
loop do
  terminates, acc = terminates?(instructions)
  # program terminates, nothing else to do
  break if terminates

  # program doesn't terminate, flip the next eligible instruction and retry
  last_flipped_index = flip_next_instruction(instructions, last_flipped_index)
  # mark all instructions as not yet visited
  instructions = instructions.map(&:reset)
end

puts acc
