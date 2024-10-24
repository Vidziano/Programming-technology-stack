
def remove_vowels(str)
  vowels = "аеєиіїоуюяАЕЄИІЇОУЮЯaeiouAEIOUаоэеиыуёюяАОЭЕИЫУЁЮЯ"

  if str.empty?
    return "Рядок порожній. Введіть будь ласка текст."
  end

  result = str.chars.reject { |char| vowels.include?(char) }.join

  if result.empty?
    return "Усі символи в рядку були голосними."
  end

  result
end

def menu
  loop do
    puts "\n-------------------------------"
    puts "Меню:"
    puts "1. Ввести рядок"
    puts "2. Вихід"
    puts "-------------------------------"
    print "Оберіть опцію: "


    choice = gets.chomp.to_i

    case choice
    when 1
      print "Введіть рядок: "
      input_str = gets.chomp

      result = remove_vowels(input_str)
      puts "Результат без голосних: #{result}"

    when 2
      puts "До побачення!"
      break
    else
      puts "Невірний вибір, спробуйте знову."
    end
  end
end

menu
