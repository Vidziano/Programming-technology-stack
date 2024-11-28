def process_numbers(array, proc_obj)
  # Перевірка, чи аргумент є масивом
  unless array.is_a?(Array)
    raise ArgumentError, "Помилка: Перший аргумент має бути масивом!"
  end

  puts "Прийнятий масив: #{array.inspect}"

  # Перевірка, чи масив містить тільки числа
  unless array.all? { |el| el.is_a?(Numeric) }
    raise ArgumentError, "Помилка: Масив має містити тільки числа!"
  end

  puts "Масив складається виключно з чисел. ✅"

  # Перевірка, чи передано проку
  unless proc_obj.is_a?(Proc)
    raise ArgumentError, "Помилка: Потрібно передати проку для обробки елементів!"
  end

  puts "Проку передано. Починаємо обробку масиву... 🔄"

  # Застосування проки до кожного елемента масиву
  result = array.map do |num|
    processed_value = proc_obj.call(num)
    puts "Елемент #{num} оброблено: #{processed_value}"
    processed_value
  end

  puts "Результат обробки масиву: #{result.inspect}"
  result
end

# Приклади використання
numbers = [10, 20, 25, 40]
puts "\n=== Початковий масив: #{numbers.inspect} ===\n\n"

begin
  # 1. Множення на 3
  puts "\n--- Приклад 1: Множення кожного числа на 3 ---"
  multiply_by_3 = Proc.new { |n| n * 3 }
  result1 = process_numbers(numbers, multiply_by_3)
  puts "Кінцевий результат: #{result1.inspect}\n"

  # 2. Віднімання 5
  puts "\n--- Приклад 2: Віднімання 5 від кожного числа ---"
  subtract_5 = Proc.new { |n| n - 5 }
  result2 = process_numbers(numbers, subtract_5)
  puts "Кінцевий результат: #{result2.inspect}\n"

  # 3. Піднесення до квадрату
  puts "\n--- Приклад 3: Квадрат кожного числа ---"
  square = Proc.new { |n| n**2 }
  result3 = process_numbers(numbers, square)
  puts "Кінцевий результат: #{result3.inspect}\n"

  # 4. Умова: подвоїти тільки парні числа
  puts "\n--- Приклад 4: Подвоїти тільки парні числа ---"
  double_even = Proc.new { |n| n.even? ? n * 2 : n }
  result4 = process_numbers(numbers, double_even)
  puts "Кінцевий результат: #{result4.inspect}\n"

  # 5. Передача неправильного аргументу (генерується помилка)
  puts "\n--- Приклад 5: Помилковий аргумент ---"
  process_numbers("not an array", multiply_by_3)

rescue ArgumentError => e
  puts "❌ Помилка: #{e.message}"
end
