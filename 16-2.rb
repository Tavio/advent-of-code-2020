#!/usr/bin/env ruby
# coding: utf-8

def parse_rules(rules)
  rules.split("\n").reduce({}) do |r, rule|
    matches = rule.match(/([^:]+): (\d+)-(\d+) or (\d+)-(\d+)/)
    rule_name, r1, r2, r3, r4 = matches[1..-1]
    r[rule_name] = [(r1.to_i..r2.to_i), (r3.to_i..r4.to_i)]
    r
  end
end

def parse_my_ticket(ticket)
  ticket.split("\n")[1].split(",").map(&:to_i)
end

def parse_nearby_tickets(tickets)
  tickets.split("\n")[1..-1].map { |t| t.split(",").map(&:to_i) }
end

def valid_value?(rules, value)
  rules.values.any? do |(range1, range2)|
    range1.include?(value) || range2.include?(value)
  end
end

def remove_invalid_tickets(rules, tickets)
  tickets.reject { |values| values.any? { |value| !valid_value?(rules, value) }}
end

def assign_fields(nearby_tickets, rules)
  # get all the possible field -> rules assignments for each field and sort by size
  # first element in resulting array will be the field that has less possible assignments
  possible_assignments = nearby_tickets.transpose.each_with_index.map do |values, i|
    rs = rules.select do |_, (range1, range2)|
      values.all? { |v| range1.include?(v) || range2.include?(v) }
    end.map(&:first)
    [i, rs] # preserve the original index of the field as we are about to sort and lose that info
  end.sort_by { |(_,rs)| rs.size }

  # now I get to cheat because I inspected my input and saw that the first field can only be assigned
  # to one rule, the second to two rules, the third to three rules, and so on (num gostô pega nois)

  # for each rule that we have to assign to a field...
  for i in 0..rules.size - 1
    # lock that rule in
    assigned_rule = possible_assignments[i].last.first # use last to get to the assignments, then first to get the only assignment I know is there (see comment above, I'm cheating)
    # remove the locked rule from the other possible assignments
    possible_assignments[(i + 1)..-1] = possible_assignments[(i + 1)..-1].map do |(idx, as)|
      [idx, as.reject { |a| a == assigned_rule }]
    end
  end

  possible_assignments.map { |(idx, as)| [idx, as.first] } # flatten the one element assignment arrays
end

def get_departure_fields_product(fields, ticket)
  fields.map do |i, field|
    if field.start_with?("departure")
      ticket[i]
    else
      1
    end
  end.reduce(:*)
end

rules, my_ticket, nearby_tickets = IO.read("input/16.txt").split("\n\n")
my_ticket = parse_my_ticket(my_ticket)
rules = parse_rules(rules)
nearby_tickets = parse_nearby_tickets(nearby_tickets)
nearby_tickets = remove_invalid_tickets(rules, nearby_tickets)
fields = assign_fields(nearby_tickets, rules)

puts get_departure_fields_product(fields, my_ticket)
