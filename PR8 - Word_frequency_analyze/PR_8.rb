# word_frequency_analyzer.rb
require 'optparse'

# Клас для аналізу частоти слів
class WordFrequencyAnalyzer
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def analyze
    validate_file!

    word_count = Hash.new(0)

    # Читання файлу та обробка слів
    File.foreach(file_path) do |line|
      words = extract_words(line)
      words.each { |word| word_count[word] += 1 }
    end

    sorted_word_count = sort_word_count(word_count)
    display_results(sorted_word_count)
  end

  private

  # Перевіряємо, чи існує файл
  def validate_file!
    unless File.exist?(file_path)
      raise IOError, "Файл не знайдено: #{@file_path}"
    end

    unless File.file?(file_path)
      raise IOError, "Вказаний шлях не є файлом: #{@file_path}"
    end

    unless File.readable?(file_path)
      raise IOError, "Файл недоступний для читання: #{@file_path}"
    end
  end

  # Витягуємо слова з рядка
  def extract_words(line)
    line.downcase.scan(/\b[\w']+\b/)
  end

  # Сортуємо слова за частотою та алфавітним порядком
  def sort_word_count(word_count)
    word_count.sort_by { |word, count| [-count, word] }
  end

  # Виведення результатів у консоль
  def display_results(sorted_word_count)
    puts "Результати аналізу (файл: #{@file_path}):"
    puts "-" * 50
    sorted_word_count.each do |word, count|
      puts "#{word.ljust(20)}: #{count}"
    end
    puts "-" * 50
  end
end

# Клас для інтерактивного меню
class InteractiveMenu
  def start
    loop do
      print_menu
      choice = gets.chomp.to_i

      case choice
      when 1
        process_analyze_file
      when 2
        display_help
      when 3
        puts "Дякую за використання! До побачення! 👋"
        break
      else
        puts "Невірний вибір. Спробуйте ще раз."
      end
    end
  end

  private

  def print_menu
    puts "\n=== Аналізатор Частоти Слів ==="
    puts "1. Аналізувати текстовий файл"
    puts "2. Допомога"
    puts "3. Вийти"
    print "Виберіть дію: "
  end

  def process_analyze_file
    print "Введіть шлях до текстового файлу: "
    file_path = gets.chomp

    begin
      analyzer = WordFrequencyAnalyzer.new(file_path)
      analyzer.analyze
    rescue IOError => e
      puts "Помилка: #{e.message}"
    rescue => e
      puts "Непередбачена помилка: #{e.message}"
    end
  end

  def display_help
    puts "\n=== Допомога ==="
    puts "Ця утиліта дозволяє аналізувати текстовий файл і отримувати частоту використання слів у ньому."
    puts "Інструкції:"
    puts "1. Виберіть опцію 'Аналізувати текстовий файл'."
    puts "2. Введіть шлях до файлу (наприклад, 'example.txt')."
    puts "3. Отримайте результати аналізу у вигляді списку зі словами та їх кількістю."
    puts "\nЩоб завершити програму, виберіть опцію 'Вийти'."
  end
end

# У кінці файлу PR_8.rb
if __FILE__ == $PROGRAM_NAME
  # Запуск меню лише при прямому виконанні файлу
  InteractiveMenu.new.start
end

