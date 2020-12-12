#!/usr/bin/env ruby

DIRECTIONS = [:north, :east, :south, :west]

class Ship

  attr_reader :facing, :x, :y

  def initialize
    @x = 0
    @y = 0
    @facing = :east
  end

  def rotate(degrees)
    @facing = DIRECTIONS[(DIRECTIONS.find_index(@facing) + (degrees / 90)) % 4]
  end

  def move(direction, distance)
    direction = @facing if direction == :forward
    case direction
    when :north
      @y += distance
    when :south
      @y -= distance
    when :east
      @x += distance
    when :west
      @x -= distance
    end
  end

  def manhattan_distance
    @x.abs + @y.abs
  end

  def to_s
    "at (#{x},#{y}), facing #{facing}"
  end
end

ship = Ship.new
File.readlines('input/12.txt', chomp: true)
    .map { |move| [move[0], move[1..-1].to_i] }
    .each do |(type, num)|
      case type
      when "N"
        ship.move(:north, num)
      when "S"
        ship.move(:south, num)
      when "E"
        ship.move(:east, num)
      when "W"
        ship.move(:west, num)
      when "L"
        ship.rotate(num * -1)
      when "R"
        ship.rotate(num)
      when "F"
        ship.move(:forward, num)
      end
    end

# Part 1:
puts ship.manhattan_distance
