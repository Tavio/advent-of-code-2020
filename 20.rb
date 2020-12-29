#!/usr/bin/env ruby

class Tile
  attr_accessor :id, :edges

  def initialize(id, image)
    @id = id
    @edges = [
      image.first, #up
      image.map{ |i| i[-1] }.join(''), #right
      image.last, #down
      image.map{ |i| i[0] }.join(''), #left
    ]
  end
end

def parse_tiles(input)
  IO.read(input)
    .split("\n\n")
    .map { |i| i.split("\n", 2) }
    .map do |(id, image)|
      Tile.new(
        id.delete_prefix("Tile ").delete_suffix(":").to_i,
        image.split("\n")
      )
    end
end

def build_edge_index(tiles)
  tiles
  .reduce({}) do |i, tile|
    tile.edges.each do |edge|
      if i[edge].nil?
        i[edge] = [tile]
        i[edge.reverse] = [tile]
      else
        i[edge] << tile
        i[edge.reverse] << tile
      end
    end
    i
  end
end

def find_borders(index)
 borders = index
  .map { |k, v| [k, v.size] }
  .reject { |k, v| v > 1 }
  .map(&:first)
end

def find_corners(tiles, borders)
  tiles.select do |tile|
    (tile.edges & borders).uniq.size == 2
  end
end

tiles = parse_tiles("input/20.txt")

index = build_edge_index(tiles)

borders = find_borders(index)

corners = find_corners(tiles, borders)

# Part 1: multiply ids of corners
mult = corners.reduce(1) do |m, c|
  m * c.id
end
puts mult
