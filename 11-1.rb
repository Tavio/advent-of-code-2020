#!/usr/bin/env ruby

class Position
  attr_accessor :row, :col, :symbol

  def initialize(row, col, symbol)
    @row = row
    @col = col
    @symbol = symbol
  end

  def update(_)
    raise 'implemented by subclass'
  end

  def occupied?
    raise 'implemented by subclass'
  end

  def unoccupied?
    !occupied?
  end

  def to_s
    symbol
  end
end

class Empty < Position

  def initialize(row, col)
    super(row, col, 'L')
  end

  def update(layout)
    if layout[row][col - 1].unoccupied? &&
       layout[row][col + 1].unoccupied? &&
       layout[row - 1][col].unoccupied? &&
       layout[row + 1][col].unoccupied? &&
       layout[row - 1][col - 1].unoccupied? &&
       layout[row - 1][col + 1].unoccupied? &&
       layout[row + 1][col - 1].unoccupied? &&
       layout[row + 1][col + 1].unoccupied?
      [Occupied.new(row, col), true]
    else
      [self, false]
    end
  end

  def occupied?
    false
  end
end

class Occupied < Position

  def initialize(row, col)
    super(row, col, '#')
  end

  def update(layout)
    num_adjacent_occupied = [
      layout[row][col - 1].occupied?,
      layout[row][col + 1].occupied?,
      layout[row - 1][col].occupied?,
      layout[row + 1][col].occupied?,
      layout[row - 1][col - 1].occupied?,
      layout[row - 1][col + 1].occupied?,
      layout[row + 1][col - 1].occupied?,
      layout[row + 1][col + 1].occupied?
    ].reject { |i| i == false }.size
    if num_adjacent_occupied >= 4
      [Empty.new(row, col), true]
    else
      [self, false]
    end
  end

  def occupied?
    true
  end
end

class Floor < Position

  def initialize(row, col)
    super(row, col, '.')
  end

  def update(_)
    [self, false]
  end

  def occupied?
    false
  end
end

def print_layout(layout)
  layout.each { |row| puts row.join(' ')}
  puts ""
  puts ""
end

def pad_layout(layout)
  # pad layout with floors so we don't have to check for array bounds later
  [Array.new(layout[0].size + 2) { |_| '.' }] +
    layout.map do |row|
      ['.'] + row + ['.']
    end +
    [Array.new(layout[0].size + 2) { |_| '.' }]
end

def parse_layout(input)
  layout = File.readlines(input, chomp: true).map { |row| row.split('') }
  layout = pad_layout(layout)
  layout
    .each_with_index.map do |row, x|
      row.each_with_index.map do |pos, y|
        case pos
        when '.'
          Floor.new(x, y)
        when 'L'
          Empty.new(x, y)
        when '#'
          Occupied.new(x, y)
        else
          puts "unknown pos: #{pos.inspect}"
        end
      end
    end
end

def simulate_one_round(layout)
  # deep copy the layout the lazy way:
  new_layout = Marshal.load(Marshal.dump(layout))

  changed = false
  layout.each_with_index do |row, x|
    row.each_with_index do |pos, y|
      new_layout[x][y], pos_changed = pos.update(layout)
      changed = changed || pos_changed
    end
  end

  [new_layout, !changed]
end

def simulate_until_done(layout, print=false)
  print_layout(layout) if print

  done = false
  while !done do
    layout, done = simulate_one_round(layout)
    print_layout(layout) if print
  end
  layout
end

def count_occupied(layout)
  layout.map { |row| row.select(&:occupied?) }.flatten.size
end

layout = parse_layout('input/11.txt')
layout = simulate_until_done(layout)

puts count_occupied(layout)
