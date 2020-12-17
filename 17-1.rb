#!/usr/bin/env ruby

def pad(matrix)
  # pad each layer with one row and one column on each end, then add one layer behind and one in front
  layers = matrix.map do |layer|
    rows = layer.map do |row|
      ['.'] + row + ['.']
    end
    rows.unshift(rows[0].size.times.map { |_| '.'})
    rows << rows[0].size.times.map { |_| '.'}
    rows
  end

  rows = layers[0].size
  cols = layers[0][0].size
  layers.unshift(rows.times.map { |_| cols.times.map { |_| '.' } })
  layers << (rows.times.map { |_| cols.times.map { |_| '.' } })
  layers
end

def active_neighbours(i, j, k, matrix)
  active = []
  for a in ([0, i-1].max) .. ([i+1, matrix.size - 1].min)
    for b in ([0, j-1].max) .. ([j+1, matrix[0].size - 1].min)
      for c in ([0, k-1].max) .. ([k+1, matrix[0][0].size - 1].min)
        next if a == i && b == j && c == k
        if matrix[a][b][c] == '#'
          active << matrix[a][b][c]
        end
      end
    end
  end
  active.size
end

def update_state(i, j, k, matrix)
  num_active_neighbours = active_neighbours(i, j, k, matrix)
  if matrix[i][j][k] == '#'
    num_active_neighbours == 2 || num_active_neighbours == 3 ? '#' : '.'
  else
    num_active_neighbours == 3 ? '#' : '.'
  end
end

def total_active_cubes(matrix)
  total = 0
  for i in 0..(matrix.size - 1) # for every layer
    for j in 0..(matrix[0].size - 1) # for every row
      for k in 0..(matrix[0][0].size - 1) # for every column
        total += 1 if matrix[i][j][k] == '#'
      end
    end
  end
  total
end

matrix = [File.readlines('input/17.txt', chomp: true).map { |line| line.split('') }]

6.times do
  matrix = pad(matrix)
  # copy the matrix since every cube has to be updated at the same time and we don't
  # want one update to influence the subsequent ones
  matrix_copy = Marshal.load(Marshal.dump(matrix))

  for i in 0..(matrix.size - 1) # for every layer
    for j in 0..(matrix[0].size - 1) # for every row
      for k in 0..(matrix[0][0].size - 1) # for every column
        matrix[i][j][k] = update_state(i, j, k, matrix_copy)
      end
    end
  end
end

puts total_active_cubes(matrix)
