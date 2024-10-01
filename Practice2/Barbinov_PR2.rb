def is_operator(operator)
  ['+', '-', '*', '/', '^', '(', ')'].include?(operator)
end

def get_priority(operator)
  if operator == '('
    0
  elsif operator == ')'
    1
  elsif operator == '+' || operator == '-'
    2
  elsif operator == '*' || operator == '/'
    3
  elsif operator == '^'
    4
  else
    6
  end
end

def to_rpn(input)
  output = ''
  stack = []
  division_by_zero = false
  last_was_operator = false

  i = 0
  while i < input.length
    current_symbol = input[i]

    unless ('0'..'9').include?(current_symbol) ||
      ('a'..'z').include?(current_symbol) ||
      ('A'..'Z').include?(current_symbol) ||
      is_operator(current_symbol) ||
      current_symbol == ' ' ||
      current_symbol == '.'
      puts "Помилка: Неприпустимий символ '#{current_symbol}'."
      return nil
    end

    next if current_symbol == ' '

    if ('0'..'9').include?(current_symbol)
      while i < input.length && (('0'..'9').include?(input[i]) || input[i] == '.')
        output += input[i]
        i += 1
      end
      output += ' '
      last_was_operator = false

    elsif ('a'..'z').include?(current_symbol) || ('A'..'Z').include?(current_symbol)
      while i < input.length && (('a'..'z').include?(input[i]) || ('A'..'Z').include?(input[i]))
        output += input[i]
        i += 1
      end
      output += ' '
      last_was_operator = false

    elsif current_symbol == '-' && (i == 0 || input[i - 1] == '(')
      output += '-'
      i += 1
      last_was_operator = false

    elsif is_operator(current_symbol)
            if last_was_operator && current_symbol != '(' && current_symbol != ')'
        puts "Помилка: Зайвий оператор '#{current_symbol}' після іншого оператора."
        return nil
      end
      if current_symbol == '('
        stack.push(current_symbol)
        last_was_operator = false
      elsif current_symbol == ')'
        while !stack.empty? && stack.last != '('
          output += stack.pop + ' '
        end
        stack.pop
        last_was_operator = false
      else
        if current_symbol == '/' && (i + 1 < input.length && input[i + 1] == '0')
          division_by_zero = true
        end

        while !stack.empty? && get_priority(current_symbol) <= get_priority(stack.last)
          output += stack.pop + ' '
        end
        stack.push(current_symbol)
        last_was_operator = true
      end
      i += 1
    end
  end

  if last_was_operator
    puts "Помилка: Вираз не може закінчуватися оператором."
    return nil
  end
  
  while stack.any?
    output += "#{stack.pop} "
  end

  if division_by_zero
    puts "На 0 ділити не можна!!!"
    return nil
  end

  output.strip
end

loop do
  puts "Меню:"
  puts "1. Ввести вираз"
  puts "2. Вихід"
  print "Виберіть опцію: "
  choice = gets.chomp

  case choice
  when '1'
    puts "Введіть вираз:"
    expression = gets.chomp
    postfix = to_rpn(expression)

    puts "Вираз у RPN: #{postfix}" if postfix
  when '2'
    puts "Вихід з програми."
    break
  else
    puts "Невірний вибір. Спробуйте ще раз."
  end
end
