#!/usr/bin/env ruby

instructions = File.readlines('input/8.txt').map do |line|
  name, number = line.split(' ')
  sign = number[0]
  number = number[1..-1].to_i
  number = sign == '+' ? number : -1 * number
  [name, number, false]
end

loop_detected = false
acc = 0
i = 0
while true
  instruction, number, visited = instructions[i]
  break if visited

  instructions[i] = [instruction, number, true]

  case instruction
  when 'acc'
    acc += number
    i += 1
  when 'jmp'
    i += number
  when 'nop'
    i += 1
  else
    raise "unknown instruction #{instruction}"
  end
end

puts acc
