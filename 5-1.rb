#!/usr/bin/env ruby

def first_half(min, max)
  [min, (max - min) / 2 + min]
end

def second_half(min, max)
  [(max - min) / 2 + min + 1, max]
end

def locate_row(pass)
  rows = pass.take(7)
  row, = rows.reduce([0, 127]) do |(min, max), partition|
    if partition == "F"
      first_half(min, max)
    else
      second_half(min, max)
    end
  end
  row
end

def locate_col(pass)
  cols = pass.drop(7)
  col, = cols.reduce([0, 7]) do |(min, max), partition|
    if partition == "L"
      first_half(min, max)
    else
      second_half(min, max)
    end
  end
  col
end

def locate_pass(pass)
  row = locate_row(pass)
  col = locate_col(pass)
  [row, col]
end

def seat_id(row, col)
  row * 8 + col
end

passes = IO.read("input/5.txt")
           .split("\n")
           .map { |pass| pass.split('') }

puts passes.map { |pass| locate_pass(pass) }
           .map { |row, col| seat_id(row, col)}
           .max
