#!/usr/bin/env ruby

def parse_passport(passport_attrs)
  passport_attrs.each_with_object({}) do |attr, passport|
    name, value = attr.split(":")
    passport[name.to_sym] = value
    passport
  end
end

def valid?(passport)
  if !!passport[:byr] &&
     !!passport[:iyr] &&
     !!passport[:eyr] &&
     !!passport[:hgt] &&
     !!passport[:hcl] &&
     !!passport[:ecl] &&
     !!passport[:pid]
    1
  else
    0
  end
end

input = IO.read("input/4.txt")
passports = input.split("\n\n").map { |p| p.split("\n").join(" ").split(" ") }
total = passports
        .map { |p| parse_passport(p) }
        .map { |p| valid?(p) }
        .reduce(:+)
puts total
