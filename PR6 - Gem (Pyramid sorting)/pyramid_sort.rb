# lib/pyramid_sort.rb
require "pyramid_sort/version"

module PyramidSort
  class Sorter
    # Реалізація сортування пірамідою
    def self.heap_sort(array)
      unless array.is_a?(Array) && array.all? { |el| el.is_a?(Numeric) }
        raise ArgumentError, "Input must be an array of numbers"
      end

      # Сортування
      n = array.length
      (n / 2 - 1).downto(0) { |i| heapify(array, n, i) }
      (n - 1).downto(1) do |i|
        array[0], array[i] = array[i], array[0]
        heapify(array, i, 0)
      end

      array
    end


    private

    # Допоміжний метод для створення піраміди
    def self.heapify(array, n, i)
      largest = i
      left = 2 * i + 1
      right = 2 * i + 2

      # Якщо лівий дочірній більший за корінь
      largest = left if left < n && array[left] > array[largest]

      # Якщо правий дочірній більший за найбільший
      largest = right if right < n && array[right] > array[largest]

      # Якщо найбільший не корінь
      if largest != i
        array[i], array[largest] = array[largest], array[i] # Обмін
        heapify(array, n, largest) # Рекурсивно перетворюємо піддерево
      end
    end
  end
end
