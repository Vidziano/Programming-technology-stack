require_relative 'Ekzamen'

RSpec.describe Statistics do
  let(:custom_collection) do
    Class.new do
      include Statistics

      attr_accessor :data

      def initialize(data = [])
        @data = data
      end

      def each(&block)
        @data.each(&block)
      end

      def size
        @data.size
      end

      def empty?
        @data.empty?
      end

      def reduce(initial, &block)
        @data.reduce(initial, &block)
      end
    end
  end

  describe '#average' do
    context 'when collection is not empty' do
      it 'обчислює середнє значення для колекції чисел' do
        collection = custom_collection.new([10, 20, 30])
        expect(collection.average).to eq(20.0)
      end

      it 'обчислює середнє значення для великих чисел' do
        collection = custom_collection.new([1_000, 2_000, 3_000])
        expect(collection.average).to eq(2_000.0)
      end
    end

    context 'when collection is empty' do
      it 'повертає 0' do
        collection = custom_collection.new([])
        expect(collection.average).to eq(0)
      end
    end
  end

  context 'when collection methods are missing' do
    it 'викидає помилку, якщо клас не реалізує потрібні методи' do
      incomplete_class = Class.new { include Statistics }.new
      expect { incomplete_class.average }.to raise_error(NotImplementedError, "Клас повинен реалізовувати методи `each`, `size` та `empty?`")
    end
  end
end

RSpec.describe Grades do
  let(:grades) { Grades.new([85, 90, 78]) }

  describe '#average' do
    it 'обчислює середній бал студентів' do
      expect(grades.average).to eq(84.33)
    end

    it 'повертає 0 для порожнього списку оцінок' do
      empty_grades = Grades.new([])
      expect(empty_grades.average).to eq(0)
    end
  end

  describe '#add_score' do
    it 'додає нову оцінку до списку' do
      grades.add_score(95)
      expect(grades.scores).to include(95)
    end

    it 'викидає помилку для оцінки поза межами діапазону' do
      expect { grades.add_score(150) }.to raise_error(ArgumentError, "Оцінка повинна бути числом в діапазоні від 0 до 100")
    end

    it 'викидає помилку для некоректного типу даних' do
      expect { grades.add_score('A') }.to raise_error(ArgumentError, "Оцінка повинна бути числом в діапазоні від 0 до 100")
    end
  end

  describe '#clear_scores' do
    it 'очищає всі оцінки' do
      grades.clear_scores
      expect(grades.scores).to be_empty
    end
  end

  describe 'Integration with Statistics' do
    it 'успадковує метод average з модуля Statistics' do
      expect(grades).to respond_to(:average)
      expect(grades.average).to eq(84.33)
    end
  end
end

RSpec.describe Student do
  let(:student) { Student.new('Анна', 'Іваненко') }

  describe '#initialize' do
    it 'створює студента з правильним ім\'ям та прізвищем' do
      expect(student.first_name).to eq('Анна')
      expect(student.last_name).to eq('Іваненко')
    end

    it 'викидає помилку, якщо ім\'я порожнє' do
      expect { Student.new('', 'Іваненко') }.to raise_error(ArgumentError, "Ім'я або прізвище повинно бути рядком і не порожнім")
    end

    it 'викидає помилку, якщо прізвище порожнє' do
      expect { Student.new('Анна', '') }.to raise_error(ArgumentError, "Ім'я або прізвище повинно бути рядком і не порожнім")
    end
  end

  describe '#full_name' do
    it 'повертає повне ім\'я студента' do
      expect(student.full_name).to eq('Іваненко Анна')
    end
  end

  describe 'Integration with Grades' do
    it 'дозволяє студенту мати оцінки' do
      student.grades.add_score(85)
      expect(student.grades.scores).to include(85)
    end

    it 'обчислює середній бал студента' do
      student.grades.add_score(85)
      student.grades.add_score(90)
      expect(student.grades.average).to eq(87.5)
    end
  end
end
