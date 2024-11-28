# Генерація чисел
producer = Ractor.new do
  numbers = (1..10).to_a # Генеруємо масив від 1 до 10
  puts "\n=== Producer ==="
  puts "-> Генеруємо масив чисел: #{numbers.inspect}"
  puts "-> Заморожуємо масив і передаємо його у Square Processor..."

  Ractor.yield(numbers.freeze, move: true) # Передаємо заморожений масив
end

# Ractor для обробки: Піднесення чисел до квадрату
square_processor = Ractor.new(producer) do |producer_ractor|
  puts "\n=== Square Processor ==="
  puts "-> Очікуємо отримання масиву від Producer..."

  numbers = producer_ractor.take # Отримуємо масив
  puts "-> Отримано масив: #{numbers.inspect}"

  # Перевірка даних
  unless numbers.is_a?(Array) && numbers.all? { |num| num.is_a?(Numeric) }
    raise "Square Processor: Некоректні дані отримано!"
  end

  puts "-> Починаємо підносити кожне число до квадрату..."
  squared_numbers = numbers.map { |num| num**2 } # Підносимо до квадрату
  puts "-> Масив після обробки (квадрати чисел): #{squared_numbers.inspect}"

  puts "-> Заморожуємо результат і передаємо у Filter Processor..."
  Ractor.yield(squared_numbers.freeze, move: true) # Передаємо оброблений масив
end

# Ractor для фільтрації: Залишаємо лише парні числа
filter_processor = Ractor.new(square_processor) do |square_ractor|
  puts "\n=== Filter Processor ==="
  puts "-> Очікуємо отримання масиву від Square Processor..."

  squared_numbers = square_ractor.take # Отримуємо оброблений масив
  puts "-> Отримано масив: #{squared_numbers.inspect}"

  # Перевірка даних
  unless squared_numbers.is_a?(Array) && squared_numbers.all? { |num| num.is_a?(Numeric) }
    raise "Filter Processor: Некоректні дані отримано!"
  end

  puts "-> Починаємо фільтрувати лише парні числа з масиву..."
  filtered_numbers = squared_numbers.select do |num|
    num.is_a?(Integer) && num.even?
  end
  puts "-> Масив після фільтрації (парні числа): #{filtered_numbers.inspect}"

  puts "-> Заморожуємо результат і передаємо у Consumer..."
  Ractor.yield(filtered_numbers.freeze, move: true) # Передаємо фільтрований масив
end

# Споживач результату
consumer = Ractor.new(filter_processor) do |filter_ractor|
  puts "\n=== Consumer ==="
  puts "-> Очікуємо отримання масиву від Filter Processor..."

  final_numbers = filter_ractor.take # Отримуємо кінцевий результат
  puts "-> Отримано кінцевий масив: #{final_numbers.inspect}"
  puts "=== Завершення роботи програми ==="
end

# Очікуємо завершення роботи споживача
consumer.take