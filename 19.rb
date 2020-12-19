#!/usr/bin/env ruby

class OrRule
  def initialize(subrules)
    @subrules = subrules
  end

  def matches(s, rules)
    @subrules.map do |subrule|
      subrule.matches(s, rules)
    end.reject(&:empty?).flatten
  end
end

class AndRule
  def initialize(subrules)
    @subrules = subrules
  end

  def matches(s, rules)
    go(@subrules, s, rules)
  end

  private

  def go(subrules, s, rules, possibilities = [''])
    return possibilities if subrules.empty? || possibilities.empty?

    next_possibilities = possibilities.map do |possibility|
      subrules.first.matches(s[(possibility.size)..-1], rules).map do |next_possibility|
        possibility + next_possibility
      end.reject(&:empty?)
    end.flatten
    go(subrules.drop(1), s, rules, next_possibilities)
  end
end

class CharacterRule
  def initialize(c)
    @c = c
    @subrules = []
  end

  def matches(s, _)
    s[0] == @c ? [@c] : []
  end
end

class RefRule
  attr_accessor :ref

  def initialize(ref)
    @ref = ref
  end

  def matches(s, rules)
    rules[@ref].matches(s, rules)
  end
end

def parse_rule(rule)
  case rule
  when /^"([a-z])"$/
    CharacterRule.new($1)
  when /\|/
    OrRule.new(rule.split("|").map { |r| parse_rule r.strip })
  when /^(\d+)$/
    RefRule.new($1.to_i)
  else
    AndRule.new(rule.split(" ").map { |r| parse_rule r.strip })
  end
end

def parse_input(input)
  rules, messages = input.split("\n\n")
  rules = rules
            .split("\n")
            .map do |r|
              idx, rule = r.split(':')
              idx.strip!
              rule.strip!
              [idx.to_i, rule]
            end
            .sort_by { |(idx, _)| idx }
            .map(&:last)
            .map { |r| parse_rule(r) }
  [rules, messages]
end

rules, messages = parse_input(IO.read("input/19-2.txt"))
total_valid = messages.split("\n").reduce(0) do |total, message|
  matches = rules[0].matches(message, rules)
  !matches.empty? && matches.first == message ? total + 1 : total
end
puts total_valid
