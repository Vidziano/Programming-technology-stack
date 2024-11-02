# encoding: utf-8

require 'json'
require 'date'
require 'terminal-table'

class Task
  attr_accessor :title, :deadline, :completed, :comment, :priority

  def initialize(title, deadline, completed = false, comment = "", priority = "середній")
    @title = title
    @deadline = parse_datetime(deadline)
    @completed = completed
    @comment = comment
    @priority = priority
  end

  def parse_datetime(datetime_str)
    return datetime_str if datetime_str.is_a?(DateTime)

    datetime_str += " 23:59" unless datetime_str.match?(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
    DateTime.strptime(datetime_str, "%Y-%m-%d %H:%M")
  rescue ArgumentError
    puts "Неправильний формат дати або часу. Будь ласка, використовуйте формат YYYY-MM-DD або YYYY-MM-DD HH:MM."
    nil
  end

  def to_h
    {
      title: @title,
      deadline: @deadline.strftime("%Y-%m-%d %H:%M"),
      completed: @completed,
      comment: @comment,
      priority: @priority
    }
  end

  def self.from_h(hash)
    deadline = DateTime.strptime(hash['deadline'], "%Y-%m-%d %H:%M") if hash['deadline']
    Task.new(hash['title'], deadline, hash['completed'], hash['comment'] || "", hash['priority'] || "середній")
  end

  def overdue?
    !@completed && @deadline < DateTime.now
  end
end


class TaskManager
  FILE_PATH = 'tasks.json'


  def initialize
    @tasks = load_tasks
  end

  def save_tasks
    File.write(FILE_PATH, JSON.pretty_generate(@tasks.map(&:to_h)))
  end

  def load_tasks
    if File.exist?(FILE_PATH)
      JSON.parse(File.read(FILE_PATH)).map { |task_data| Task.from_h(task_data) }
    else
      []
    end
  end

  def add_task(title, deadline, comment = "", priority = "середній")
    task = Task.new(title, deadline, false, comment, priority)
    if task.deadline
      @tasks << task
      puts "Завдання успішно додано!"
    else
      puts "Не вдалося додати завдання. Неправильний формат дати або часу."
    end
  end

  def tasks_empty?
    @tasks.empty?
  end

  def display_tasks
    if tasks_empty?
      puts "Список завдань порожній."
    else
      table = Terminal::Table.new do |t|
        t.title = "Список Завдань"
        t.headings = ['#', 'Назва', 'Дедлайн', 'Статус', 'Пріоритет', 'Коментар']
        @tasks.each_with_index do |task, index|
          t.add_row [
                      index + 1,
                      task.title,
                      task.deadline.strftime("%Y-%m-%d %H:%M"),
                      task.completed ? '✔ Виконано' : '✘ Не виконано',
                      task.priority.capitalize,
                      task.comment
                    ]
          t.add_separator unless index == @tasks.size - 1
        end
      end
      puts table
    end
  end

  def edit_task(index, new_title = nil, new_deadline = nil, new_comment = nil, new_priority = nil)
    if index_valid?(index)
      task = @tasks[index]
      task.title = new_title if new_title
      task.deadline = Task.new("", new_deadline).deadline if new_deadline
      task.comment = new_comment if new_comment
      task.priority = new_priority if new_priority
      puts "Завдання успішно оновлено!"
    else
      puts "Невірний індекс завдання для редагування."
    end
  end

  def toggle_task_status(index)
    if index_valid?(index)
      task = @tasks[index]
      task.completed = !task.completed
      puts "Статус завдання оновлено!"
    else
      puts "Невірний індекс завдання для зміни статусу."
    end
  end

  def delete_task(index)
    if index_valid?(index)
      @tasks.delete_at(index)
      puts "Завдання успішно видалено!"
    else
      puts "Невірний індекс завдання для видалення."
    end
  end

  def clear_tasks
    return puts "Список завдань порожній." if tasks_empty?

    @tasks.clear
    puts "Усі завдання видалено!"
  end

  def display_statistics
    total_tasks = @tasks.size
    completed_tasks = @tasks.count(&:completed)
    pending_tasks = total_tasks - completed_tasks
    overdue_tasks = @tasks.count(&:overdue?)

    puts "\nСтатистика по завданням:"
    puts "Загальна кількість завдань: #{total_tasks}"
    puts "Виконаних завдань: #{completed_tasks}"
    puts "Невиконаних завдань: #{pending_tasks}"
    puts "Прострочених завдань: #{overdue_tasks}"
  end

  def display_overdue_tasks
    overdue_tasks = @tasks.select(&:overdue?)
    if overdue_tasks.empty?
      puts "Немає прострочених завдань."
    else
      table = Terminal::Table.new do |t|
        t.title = "Прострочені Завдання"
        t.headings = ['#', 'Назва', 'Дедлайн', 'Статус', 'Пріоритет', 'Коментар']
        overdue_tasks.each_with_index do |task, index|
          t.add_row [
                      index + 1,
                      task.title,
                      task.deadline.strftime("%Y-%m-%d %H:%M"),
                      task.completed ? '✔ Виконано' : '✘ Не виконано',
                      task.priority.capitalize,
                      task.comment
                    ]
          t.add_separator unless index == overdue_tasks.size - 1
        end
      end
      puts table
    end
  end

  def display_filtered_tasks(status: nil, title: nil, deadline: nil, priority: nil)
    filtered_tasks = @tasks

    filtered_tasks = filtered_tasks.select { |task| task.completed == status } unless status.nil?

    filtered_tasks = filtered_tasks.select { |task| task.title.include?(title) } if title

    if deadline
      begin
        target_date = Date.parse(deadline)
        filtered_tasks = filtered_tasks.select { |task| task.deadline.to_date == target_date }
      rescue ArgumentError
        puts "Неправильний формат дати. Будь ласка, використовуйте формат YYYY-MM-DD."
        return
      end
    end

    filtered_tasks = filtered_tasks.select { |task| task.priority == priority } if priority

    if filtered_tasks.empty?
      puts "Немає завдань, що відповідають критеріям фільтрації."
    else
      table = Terminal::Table.new do |t|
        t.title = "Фільтровані Завдання"
        t.headings = ['#', 'Назва', 'Дедлайн', 'Статус', 'Пріоритет', 'Коментар']
        filtered_tasks.each_with_index do |task, index|
          t.add_row [
                      index + 1,
                      task.title,
                      task.deadline.strftime("%Y-%m-%d %H:%M"),
                      task.completed ? '✔ Виконано' : '✘ Не виконано',
                      task.priority.capitalize,
                      task.comment
                    ]
          t.add_separator unless index == filtered_tasks.size - 1
        end
      end
      puts table
    end
  end


  def sort_by_deadline
    @tasks.sort_by!(&:deadline)
    puts "Список відсортовано за дедлайном."
  end

  def sort_by_priority
    priority_order = { "високий" => 0, "середній" => 1, "низький" => 2 }
    @tasks.sort_by! { |task| priority_order[task.priority] }
    puts "Список відсортовано за пріоритетом."
  end

  def sort_by_status_incomplete_first
    @tasks.sort_by! { |task| [task.completed ? 1 : 0, task.deadline] }
    puts "Список відсортовано за статусом (спочатку невиконані)."
  end

  def sort_by_status_complete_first
    @tasks.sort_by! { |task| [task.completed ? 0 : 1, task.deadline] }
    puts "Список відсортовано за статусом (спочатку виконані)."
  end

  def sort_by_name
    @tasks.sort_by!(&:title)
    puts "Список відсортовано за назвою (алфавітне)."
  end

  private

  def index_valid?(index)
    index.between?(0, @tasks.size - 1)
  end
end

def main_menu
  manager = TaskManager.new

  loop do
    puts "\nМеню керування завданнями"
    puts "1. Додати нове завдання"
    puts "2. Редагувати завдання"
    puts "3. Змінити статус завдання"
    puts "4. Вивести всі завдання"
    puts "5. Сортувати завдання"
    puts "6. Вивести виконані завдання"
    puts "7. Вивести невиконані завдання"
    puts "8. Фільтрувати завдання за назвою"
    puts "9. Фільтрувати завдання за датою"
    puts "10. Фільтрувати завдання за пріоритетом"
    puts "11. Видалити завдання"
    puts "12. Очистити всі завдання"
    puts "13. Вивести статистику"
    puts "14. Вивести прострочені завдання"
    puts "0. Вихід"

    print "\nОберіть опцію: "
    choice = gets.chomp

    case choice
    when "1"
      print "Введіть назву завдання: "
      title = gets.chomp
      print "Введіть дедлайн завдання (YYYY-MM-DD або YYYY-MM-DD HH:MM): "
      deadline = gets.chomp
      print "Введіть коментар (або натисніть Enter, щоб пропустити): "
      comment = gets.chomp
      print "Введіть пріоритет (низький, середній, високий): "
      priority = gets.chomp.downcase
      manager.add_task(title, deadline, comment, priority)
    when "2"
      if manager.tasks_empty?
        puts "Список завдань порожній."
      else
        manager.display_tasks
        print "Введіть індекс завдання для редагування: "
        index = gets.chomp.to_i - 1
        print "Введіть нову назву (або натисніть Enter, щоб залишити без змін): "
        new_title = gets.chomp
        print "Введіть новий дедлайн (YYYY-MM-DD або YYYY-MM-DD HH:MM, або натисніть Enter, щоб залишити без змін): "
        new_deadline = gets.chomp
        print "Введіть новий коментар (або натисніть Enter, щоб залишити без змін): "
        new_comment = gets.chomp
        print "Введіть новий пріоритет (низький, середній, високий, або натисніть Enter для збереження поточного): "
        new_priority = gets.chomp.downcase
        manager.edit_task(index, new_title.empty? ? nil : new_title, new_deadline.empty? ? nil : new_deadline, new_comment.empty? ? nil : new_comment, new_priority.empty? ? nil : new_priority)
      end
    when "3"
      if manager.tasks_empty?
        puts "Список завдань порожній."
      else
        manager.display_tasks
        print "Введіть індекс завдання для зміни статусу: "
        index = gets.chomp.to_i - 1
        manager.toggle_task_status(index)
      end
    when "4"
      manager.display_tasks
    when "5"
      sort_submenu(manager)
    when "6"
      manager.display_filtered_tasks(status: true)
    when "7"
      manager.display_filtered_tasks(status: false)
    when "8"
      print "Введіть назву для фільтрації: "
      title = gets.chomp
      manager.display_filtered_tasks(title: title)
    when "9"
      print "Введіть дату для фільтрації (YYYY-MM-DD): "
      date = gets.chomp
      manager.display_filtered_tasks(deadline: date)
    when "10"
      print "Введіть пріоритет для фільтрації (низький, середній, високий): "
      priority = gets.chomp.downcase
      manager.display_filtered_tasks(priority: priority)
    when "11"
      if manager.tasks_empty?
        puts "Список завдань порожній."
      else
        manager.display_tasks
        print "Введіть індекс завдання для видалення: "
        index = gets.chomp.to_i - 1
        manager.delete_task(index)
      end
    when "12"
      manager.clear_tasks
    when "13"
      manager.display_statistics
    when "14"
      manager.display_overdue_tasks
    when "0"
      manager.save_tasks
      puts "Зміни збережено. Вихід..."
      break
    else
      puts "Неправильна опція. Спробуйте ще раз."
    end
  end
end

def sort_submenu(manager)
  puts "\nПідменю сортування завдань"
  puts "1. Сортувати за дедлайном"
  puts "2. Сортувати за пріоритетом"
  puts "3. Сортувати за статусом (спочатку невиконані)"
  puts "4. Сортувати за статусом (спочатку виконані)"
  puts "5. Сортувати за назвою (алфавітне)"

  print "\nОберіть варіант сортування: "
  choice = gets.chomp

  case choice
  when "1"
    manager.sort_by_deadline
  when "2"
    manager.sort_by_priority
  when "3"
    manager.sort_by_status_incomplete_first
  when "4"
    manager.sort_by_status_complete_first
  when "5"
    manager.sort_by_name
  else
    puts "Неправильна опція сортування. Повернення до головного меню."
  end
end

main_menu
