#!/usr/bin/env ruby

def parse_passports(input)
  input.split("\n\n").map { |p| p.split("\n").join(" ").split(" ") }
end

def parse_passport(passport)
  passport.each_with_object({}) do |attr, p|
    name, value = attr.split(":")
    p[name.to_sym] = value
    p
  end
end

def year_valid?(passport, attr, min, max)
  if passport[attr]
    year = passport[attr].to_i
    return year >= min && year <= max
  end
  false
end

def height_valid?(passport)
  if passport[:hgt] && matches = passport[:hgt].match(/(\d+)(in|cm)/)
    height = matches[1].to_i
    unit = matches[2]
    return unit == "in" && height >= 59 && height <= 76 || unit == "cm" && height >= 150 && height <= 193
  end
  false
end

def hair_color_valid?(passport)
  /^#[0-9a-f]{6}$/ =~ passport[:hcl]
end

def eye_color_valid?(passport)
  /^amb|blu|brn|gry|grn|hzl|oth$/ =~ passport[:ecl]
end

def pid_valid?(passport)
  /^\d{9}$/ =~ passport[:pid]
end

def valid?(passport)
  year_valid?(passport, :byr, 1920, 2002) &&
  year_valid?(passport, :iyr, 2010, 2020) &&
  year_valid?(passport, :eyr, 2020, 2030) &&
  height_valid?(passport) &&
  hair_color_valid?(passport) &&
  eye_color_valid?(passport) &&
  pid_valid?(passport)
end


input = IO.read("input/4.txt")
passports = parse_passports(input)
total = passports
        .map { |p| parse_passport(p) }
        .select { |p| valid?(p) }
        .size
puts total
