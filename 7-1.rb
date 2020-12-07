#!/usr/bin/env ruby

def build_inverted_index(input)
  inverted_index = {}

  File.readlines(input).each do |rule|
    container, contained = rule.split("contain").map(&:strip)
    container.delete_suffix!('s')
    contained = contained.split(",").map(&:strip).map do |c|
      matches = c.match(/(?:(\d+)\s)?((?:.+)bag)s?\.?/)
      colour = matches[2]
      colour
    end

    inverted_index = contained.each_with_object(inverted_index) do |bag, idx|
      if idx[bag].nil?
        idx[bag] = Set.new
      end
      idx[bag].add(container)
      idx
    end
  end

  inverted_index
end

def search_container(inverted_index, bags, result = Set.new)
  if bags.empty?
    result
  else
    new_bags = bags.each_with_object(Set.new) do |b, s|
      s.merge(inverted_index[b] || Set.new)
    end
    search_container(inverted_index, new_bags, result.merge(new_bags))
  end
end

inverted_index = build_inverted_index('input/7.txt')

puts search_container(inverted_index, Set.new(["shiny gold bag"])).size
