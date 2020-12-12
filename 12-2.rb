#!/usr/bin/env ruby
# coding: utf-8

class Waypoint
  attr_reader :x, :y

  def initialize
    @x = 10.0
    @y = 1.0
  end

  def rotate(degrees)
    # We utilise the multiplication matrix below:
    #  ________________
    # |                |
    # | cos θ   -sin θ |
    # |                |
    # | sin θ   cos θ  |
    #  ________________
    #
    # to rotate the waypoint around the origin (the ship is at the origin of
    # the waypoint's plane by our convention). The degrees have to be converted
    # to radians first, as required by Ruby's sin and cos functions; we also multiply
    # them by -1 as the rotation matrix above works in counter-clockwise fashion.
    #
    # See also: https://en.wikipedia.org/wiki/Rotation_matrix

    degrees = -1 * degrees * Math::PI / 180
    cos = Math.cos(degrees)
    sin = Math.sin(degrees)
    curr_x = @x
    curr_y = @y
    @x = curr_x * cos - curr_y * sin
    @y = curr_x * sin + curr_y * cos
  end

  def move(direction, distance)
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

  private

  def to_s
    "waypoint at (#{@x}, #{@y})"
  end
end

class Ship
  def initialize
    @x = 0.0
    @y = 0.0
    @waypoint = Waypoint.new
  end

  def rotate(degrees)
    @waypoint.rotate(degrees)
  end

  def move(direction, distance)
    case direction
    when :forward
      @x += @waypoint.x * distance
      @y += @waypoint.y * distance
    else
      @waypoint.move(direction, distance)
    end
  end

  def manhattan_distance
    @x.abs + @y.abs
  end

  def to_s
    "at (#{@x},#{@y}), #{@waypoint}"
  end
end

ship = Ship.new
puts ship
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
      puts ship
    end

puts ship.manhattan_distance
