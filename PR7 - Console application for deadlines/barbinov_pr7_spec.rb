require_relative '../Barbinov_PR7'

RSpec.describe 'Task та TaskManager' do
  # ---- Тести для Task ----
  describe Task do
    let(:task) { Task.new("Test Task", "2024-12-05", false, "Test comment", "високий") }

    describe '#initialize' do
      it 'створює обʼєкт завдання з правильними параметрами' do
        expect(task.title).to eq("Test Task")
        expect(task.deadline).to be_a(DateTime)
        expect(task.deadline.strftime("%Y-%m-%d")).to eq("2024-12-05")
        expect(task.completed).to eq(false)
        expect(task.comment).to eq("Test comment")
        expect(task.priority).to eq("високий")
      end
    end

    describe '#overdue?' do
      it 'повертає true, якщо завдання прострочене' do
        allow(DateTime).to receive(:now).and_return(DateTime.parse("2024-12-06"))
        expect(task.overdue?).to be(true)
      end

      it 'повертає false, якщо завдання не прострочене' do
        allow(DateTime).to receive(:now).and_return(DateTime.parse("2024-12-04"))
        expect(task.overdue?).to be(false)
      end
    end

    describe '#to_h' do
      it 'повертає хеш із правильними ключами та значеннями' do
        expect(task.to_h).to eq({
                                  title: "Test Task",
                                  deadline: "2024-12-05 23:59",
                                  completed: false,
                                  comment: "Test comment",
                                  priority: "високий"
                                })
      end
    end
  end

  # ---- Тести для TaskManager ----
  describe TaskManager do
    let(:manager) { TaskManager.new }

    before do
      allow(manager).to receive(:load_tasks).and_return([]) # Уникаємо завантаження реального файлу
      manager.add_task("Test Task", "2024-12-05", "Test comment", "середній")
    end

    # --- 1. Некоректний формат дати ---
    describe '#add_task' do
      it 'не додає завдання з некоректною датою' do
        manager.add_task("Invalid Date Task", "2024-13-05", "Invalid test", "середній")
        expect(manager.instance_variable_get(:@tasks).size).to eq(1) # тільки початкове завдання
      end

      it 'не додає завдання з порожньою назвою' do
        manager.add_task("", "2024-12-05", "No title test", "середній")
        expect(manager.instance_variable_get(:@tasks).size).to eq(1)
      end

      it 'виводить повідомлення при некоректному форматі дати' do
        expect { manager.add_task("Invalid Date Task", "incorrect_date", "Test comment", "середній") }
          .to output(/Неправильний формат дати або часу/).to_stdout
      end
    end

    # --- 2. Видалення завдань ---
    describe '#delete_task' do
      it 'не видаляє завдання за індексом, що виходить за межі' do
        expect { manager.delete_task(5) }.not_to raise_error
        expect(manager.instance_variable_get(:@tasks).size).to eq(1)
      end
    end

    # --- 3. Робота з порожнім списком ---
    describe '#display_tasks' do
      it 'виводить повідомлення, якщо список завдань порожній' do
        manager.delete_task(0) # очищаємо список завдань
        expect { manager.display_tasks }.to output(/Список завдань порожній/).to_stdout
      end
    end

    # --- 4. Прострочені завдання ---
    describe '#display_overdue_tasks' do
      it 'коректно виводить прострочені завдання' do
        allow(DateTime).to receive(:now).and_return(DateTime.parse("2024-12-06"))
        expect { manager.display_overdue_tasks }.to output(/Test Task/).to_stdout
      end

      it 'виводить повідомлення, якщо немає прострочених завдань' do
        allow(DateTime).to receive(:now).and_return(DateTime.parse("2024-12-04"))
        expect { manager.display_overdue_tasks }.to output(/Немає прострочених завдань/).to_stdout
      end
    end

    # --- 5. Сортування ---
    describe '#sort_by_deadline' do
      it 'сортує завдання за дедлайном' do
        manager.add_task("Another Task", "2024-12-01", "Test comment", "високий")
        manager.sort_by_deadline
        tasks = manager.instance_variable_get(:@tasks)
        expect(tasks.first.title).to eq("Another Task")
        expect(tasks.last.title).to eq("Test Task")
      end
    end

    describe '#sort_by_priority' do
      it 'сортує завдання за пріоритетом' do
        manager.add_task("Low Priority Task", "2024-12-15", "Test comment", "низький")
        manager.add_task("High Priority Task", "2024-12-10", "Test comment", "високий")
        manager.sort_by_priority
        tasks = manager.instance_variable_get(:@tasks)
        expect(tasks.first.priority).to eq("високий")
        expect(tasks.last.priority).to eq("низький")
      end
    end

    describe '#sort_by_name' do
      it 'сортує завдання за назвою (алфавітно)' do
        manager.add_task("Zebra Task", "2024-12-10", "Test comment", "високий")
        manager.add_task("Apple Task", "2024-12-15", "Test comment", "низький")
        manager.sort_by_name
        tasks = manager.instance_variable_get(:@tasks)
        expect(tasks.first.title).to eq("Apple Task")
        expect(tasks.last.title).to eq("Zebra Task")
      end
    end

    # --- 6. Робота зі статусом ---
    describe '#toggle_task_status' do
      it 'змінює статус завдання на виконаний' do
        manager.toggle_task_status(0)
        task = manager.instance_variable_get(:@tasks).first
        expect(task.completed).to eq(true)
      end

      it 'змінює статус завдання на невиконаний' do
        manager.toggle_task_status(0) # виконуємо
        manager.toggle_task_status(0) # повертаємо у невиконаний
        task = manager.instance_variable_get(:@tasks).first
        expect(task.completed).to eq(false)
      end
    end

    # --- 7. Статистика ---
    describe '#display_statistics' do
      it 'виводить коректну статистику для невиконаних і прострочених завдань' do
        allow(DateTime).to receive(:now).and_return(DateTime.parse("2024-12-06"))
        expect { manager.display_statistics }.to output(/Загальна кількість завдань: 1/).to_stdout
        expect { manager.display_statistics }.to output(/Невиконаних завдань: 1/).to_stdout
        expect { manager.display_statistics }.to output(/Прострочених завдань: 1/).to_stdout
      end
    end

    # --- 8. Збереження та завантаження ---
    describe '#save_tasks' do
      let(:file_path) { TaskManager::FILE_PATH }

      after do
        File.delete(file_path) if File.exist?(file_path) # Очищення після тесту
      end

      it 'зберігає завдання у файл JSON' do
        manager.save_tasks
        expect(File.exist?(file_path)).to be true

        data = JSON.parse(File.read(file_path))
        expect(data.size).to eq(1)
        expect(data.first['title']).to eq("Test Task")
      end

      it 'додає завдання у файл JSON' do
        manager.add_task("Another Task", "2024-12-06", "Another comment", "високий")
        manager.save_tasks

        data = JSON.parse(File.read(file_path))
        expect(data.size).to eq(2)
        expect(data.last['title']).to eq("Another Task")
      end
    end
  end
end
