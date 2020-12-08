#!/usr/bin/env ruby

def build_index(input)
  index = {}

  File.readlines(input).each do |rule|
    container, contained = rule.split("contain").map(&:strip)
    container.delete_suffix!('s')
    contained = contained.split(",").map(&:strip).map do |c|
      matches = c.match(/(?:(\d+)\s)?((?:.+)bag)s?\.?/)
      amount = matches[1].to_i
      colour = matches[2]
      [amount, colour]
    end

    index = contained.each_with_object(index) do |(amount, bag), idx|
      if idx[container].nil?
        idx[container] = []
      end
      idx[container] << [amount, bag]
      idx
    end
  end

  index
end

def count_bags(index, bags, result = 0)
  if bags.empty?
    result
  else
    next_bags = bags.reduce([]) do |s, (amount, colour)|
      s + (index[colour] || []).map { |a, c| [a * amount, c] }
    end
    next_result = result + bags.reduce(0) { |sum, (amount, _)| sum + amount}
    count_bags(index, next_bags, next_result)
  end
end

index = build_index('input/7.txt')

puts count_bags(index, [[1, "shiny gold bag"]]) - 1
