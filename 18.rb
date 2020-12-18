#!/usr/bin/env ruby

def index_of_matching_right_paren(expression)
  num_left_parens = 0
  num_right_parens = 0
  for i in 1..expression.size - 1
    case expression[i]
    when '('
      num_left_parens += 1
    when ')'
      num_right_parens += 1
      break if num_right_parens > num_left_parens
    end
  end
  i
end

def index_of_matching_left_paren(expression)
  num_left_parens = 0
  num_right_parens = 0
  for i in (expression.size - 2).downto(0)
    case expression[i]
    when ')'
      num_right_parens += 1
    when '('
      num_left_parens += 1
      break if num_left_parens > num_right_parens
    end
  end
  i
end

def peel(expression)
  # takes an expression that starts with a left parenthesis and finds the right
  # parens that matches it, then returns both the subexpression inside those parenthesis
  # and the rest of the original expression that is outside the parenthesis
  i = index_of_matching_right_paren(expression)
  return expression[1..(i-1)], expression[(i+1)..-1]
end

def apply(operator, op1, op2)
  case operator
  when '+'
    op1 + op2
  when '*'
    op1 * op2
  end
end

def solve(expression, result = [])
  return result.first if expression.empty?

  next_elem = expression.first
  case next_elem
  when '('
    sub_expression, rest = peel(expression)
    sub_result = solve(sub_expression)
    solve([sub_result] + rest, result)
  when '+','*'
    solve(expression.drop(1), result + [next_elem])
  else
    if result.last == '+' || result.last == '*'
      op1, operator = result[-2..-1]
      new_result = result.drop(2) + [apply(operator, op1, next_elem)]
      solve(expression.drop(1), new_result)
    else
      solve(expression.drop(1), result + [next_elem])
    end
  end
end

def parse_expression(expression, with_addition_precedence)
  expression.gsub!(' ', '')
  if with_addition_precedence
    expression = parenthise_additions(expression)
  end
  expression
    .split('')
    .map do |x|
      if (matches = x.match(/(\d+)/))
        matches[1].to_i
      else
        x
      end
    end
end

def run(expr, with_addition_precedence = false)
  solve(parse_expression(expr, with_addition_precedence))
end

def parenthise_additions(expression, idx = 0)
  return expression if idx >= expression.size - 1

  case expression[idx]
  when '+'
    left = expression[idx - 1] == ')' ? index_of_matching_left_paren(expression[0..(idx-1)]) : idx - 1
    right = expression[idx + 1] == '(' ? index_of_matching_right_paren(expression[(idx+1)..-1]) + idx + 1 : idx + 1
    right += 2 # compensate for left paren which gets added first
    expression.insert(left, '(')
    expression.insert(right, ')')
    parenthise_additions(expression, idx + 2)
  else
    parenthise_additions(expression, idx + 1)
  end
end

# part1 = File.readlines('input/18.txt')
#           .map { |expr| run(expr) }
#           .reduce(:+)
# puts part1

part2 = File.readlines('input/18.txt')
          .map { |expr| run(expr, true) }
          .reduce(:+)
puts part2
