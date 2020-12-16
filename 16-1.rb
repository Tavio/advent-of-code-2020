#!/usr/bin/env ruby

def parse_rules(rules)
  rules.split("\n").reduce({}) do |r, rule|
    matches = rule.match(/([^:]+): (\d+)-(\d+) or (\d+)-(\d+)/)
    rule_name, r1, r2, r3, r4 = matches[1..-1]
    r[rule_name] = [(r1.to_i..r2.to_i), (r3.to_i..r4.to_i)]
    r
  end
end

def parse_nearby_tickets(tickets)
  tickets.split("\n")[1..-1].map { |t| t.split(",").map(&:to_i) }
end

def valid_value?(rules, value)
  rules.values.any? do |(range1, range2)|
    range1.include?(value) || range2.include?(value)
  end
end

def find_invalid_values(rules, tickets)
  tickets.reduce([]) do |invalid_values, values|
    invalid_values << values.reject { |v| valid_value?(rules, v) }
    invalid_values
  end.flatten
end

rules, my_ticket, nearby_tickets = IO.read("input/16.txt").split("\n\n")
rules = parse_rules(rules)
nearby_tickets = parse_nearby_tickets(nearby_tickets)

invalid_values = find_invalid_values(rules, nearby_tickets)
puts invalid_values.reduce(:+)
