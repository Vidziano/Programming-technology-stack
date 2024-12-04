require_relative "lib/pyramid_sort"

def menu
  loop do
    puts "\n--- Pyramid Sort Program ---"
    puts "1. Ввести масив вручну"
    puts "2. Згенерувати випадковий масив"
    puts "3. Вийти"
    print "Ваш вибір: "
    choice = gets.to_i

    case choice
    when 1
      manual_input
    when 2
      random_array
    when 3
      puts "Дякуємо за використання програми!"
      break
    else
      puts "Некоректний вибір. Спробуйте знову."
    end
  end
end

def manual_input
  print "Введіть числа через кому (наприклад, 4, 10, 3, 5, 1): "
  input = gets.chomp
  array = input.split(",").map(&:to_f) # Використання to_f для дробових чисел
  process_array(array)
end

def random_array
  print "Введіть розмір масиву: "
  size = gets.to_i
  print "Введіть мінімальне значення: "
  min = gets.to_i
  print "Введіть максимальне значення: "
  max = gets.to_i

  array = Array.new(size) { rand(min..max).to_i } # Генерація тільки цілих чисел
  puts "Згенерований масив: #{array.inspect}"
  process_array(array)
end

def process_array(array)
  puts "Оригінальний масив: #{array.inspect}"

  # Логіка перевірок
  check_array(array)

  # Сортування масиву
  begin
    sorted_array = PyramidSort::Sorter.heap_sort(array.dup)
    puts "Відсортований масив: #{sorted_array.inspect}"
  rescue ArgumentError => e
    puts "Помилка: #{e.message}"
  end
end

def check_array(array)
  if array.empty?
    puts "Масив порожній."
    return
  end

  if sorted?(array)
    puts "Масив вже відсортований у зростаючому порядку."
  elsif reverse_sorted?(array)
    puts "Масив відсортований у зворотному порядку."
  end

  if duplicates?(array)
    puts "Масив містить повторювані елементи."
  end
end

def sorted?(array)
  array.each_cons(2).all? { |a, b| a <= b }
end

def reverse_sorted?(array)
  array.each_cons(2).all? { |a, b| a >= b }
end

def duplicates?(array)
  array.uniq.length != array.length
end

# Запуск програми
menu
