#!/usr/bin/env ruby

# Direction vectors:
UP = [-1, 0]
DOWN = [1, 0]
LEFT = [0, -1]
RIGHT = [0, 1]
UP_LEFT = [-1, -1]
UP_RIGHT = [-1, 1]
DOWN_LEFT = [1, -1]
DOWN_RIGHT = [1, 1]
ALL_DIRECTIONS = [UP, DOWN, LEFT, RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT]

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

  def next_position_in_direction(direction, layout)
    x, y = direction
    next_row = row + x
    next_col = col + y

    return nil if next_row < 0 || next_row >= layout.size || next_col < 0 || next_col >= layout[0].size

    layout[next_row][next_col]
  end

  def can_see_any_occupied_seat?(layout)
    ALL_DIRECTIONS.each do |direction|
      next_pos = next_position_in_direction(direction, layout)
      while next_pos do
        return true if next_pos.occupied?
        break if next_pos.is_a?(Empty) # empty seat breaks line of sight

        next_pos = next_pos.next_position_in_direction(direction, layout)
      end
    end
    false
  end

  def count_occupied_seats_in_view(layout)
    ALL_DIRECTIONS.map do |direction|
      occupied_seat_in_direction = 0
      next_pos = next_position_in_direction(direction, layout)
      while next_pos do
        if next_pos.occupied?
          occupied_seat_in_direction = 1
          break
        end
        break if next_pos.is_a?(Empty) # empty seat breaks line of sight

        next_pos = next_pos.next_position_in_direction(direction, layout)
      end
      occupied_seat_in_direction
    end.reduce(:+)
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
    if !can_see_any_occupied_seat?(layout)
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
    if count_occupied_seats_in_view(layout) >= 5
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
  layout.each { |row| puts row.join('')}
  puts ""
  puts ""
end

def parse_layout(input)
  layout = File.readlines(input, chomp: true).map { |row| row.split('') }
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
