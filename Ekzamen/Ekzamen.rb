require 'terminal-table'

# Модуль для розрахунку середнього значення
module Statistics
  def average
    if !respond_to?(:each) || !respond_to?(:size) || !respond_to?(:empty?)
      raise NotImplementedError, "Клас повинен реалізовувати методи `each`, `size` та `empty?`"
    end

    return 0 if empty?

    sum = reduce(0.0) { |total, value| total + value }
    (sum / size).round(2)
  end
end

# Клас для роботи з оцінками студентів
class Grades
  include Statistics

  attr_accessor :scores

  def initialize(scores = [])
    @scores = validate_scores(scores)
  end

  def validate_scores(scores)
    unless scores.is_a?(Array) && scores.all? { |s| s.is_a?(Numeric) && s.between?(0, 100) }
      raise ArgumentError, "Оцінки повинні бути числовими значеннями в діапазоні від 0 до 100"
    end
    scores
  end

  def each(&block)
    @scores.each(&block)
  end

  def size
    @scores.size
  end

  def empty?
    @scores.empty?
  end

  def reduce(initial, &block)
    @scores.reduce(initial, &block)
  end

  def add_score(score)
    if score.is_a?(Numeric) && score.between?(0, 100)
      @scores << score
    else
      raise ArgumentError, "Оцінка повинна бути числом в діапазоні від 0 до 100"
    end
  end

  def clear_scores
    @scores.clear
  end
end

# Клас для студентів
class Student
  attr_accessor :first_name, :last_name, :grades

  def initialize(first_name, last_name)
    validate_name(first_name)
    validate_name(last_name)

    @first_name = first_name.strip.capitalize
    @last_name = last_name.strip.capitalize
    @grades = Grades.new
  end

  def full_name
    "#{last_name} #{first_name}"
  end

  private

  def validate_name(name)
    unless name.is_a?(String) && !name.strip.empty?
      raise ArgumentError, "Ім'я або прізвище повинно бути рядком і не порожнім"
    end
  end
end

# Меню для користувача
def grades_menu
  students = []

  loop do
    puts "\n=== Меню ==="
    puts "1. Додати студента"
    puts "2. Додати оцінку студенту"
    puts "3. Показати всі оцінки студентів"
    puts "4. Очистити всі дані"
    puts "5. Вийти"
    print "Ваш вибір: "
    choice = gets.chomp.to_i

    case choice
    when 1
      print "Введіть ім'я студента: "
      first_name = gets.chomp
      print "Введіть прізвище студента: "
      last_name = gets.chomp

      begin
        student = Student.new(first_name, last_name)
        students << student
        puts "Студента #{student.full_name} додано."
      rescue ArgumentError => e
        puts "Помилка: #{e.message}"
      end

    when 2
      if students.empty?
        puts "Немає студентів. Додайте спочатку студента."
      else
        puts "Оберіть студента, ввівши номер:"
        students.each_with_index do |student, index|
          puts "#{index + 1}. #{student.full_name}"
        end

        student_index = gets.chomp.to_i - 1
        if student_index.between?(0, students.size - 1)
          print "Введіть оцінку (0-100): "
          score = gets.chomp.to_f
          begin
            students[student_index].grades.add_score(score)
            puts "Оцінку #{score} додано студенту #{students[student_index].full_name}."
          rescue ArgumentError => e
            puts "Помилка: #{e.message}"
          end
        else
          puts "Невірний вибір студента."
        end
      end

    when 3
      if students.empty?
        puts "Немає даних для виводу."
      else
        rows = students.map do |student|
          [student.full_name, student.grades.scores.join(", "), student.grades.average]
        end

        table = Terminal::Table.new(
          title: "Список студентів",
          headings: ["Прізвище та ім'я", "Оцінки", "Середній бал"],
          rows: rows
        )
        puts table
      end

    when 4
      students.clear
      puts "Усі дані очищено."

    when 5
      puts "Вихід з програми. До побачення!"
      break

    else
      puts "Невірний вибір. Будь ласка, оберіть з пунктів меню."
    end
  end
end

# Запуск програми
grades_menu