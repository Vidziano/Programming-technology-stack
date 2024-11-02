
class PieCutter

  def self.cut(matrix, raisin = 'o', max_targets = 9)
    if matrix.nil? || raisin.nil? || raisin.empty?
      puts 'Помилка! Невірний вхід. Матриця або символ не можуть бути nil або порожніми!'
      return nil
    end

    raisin_count = 0
    matrix.each do |row|
      raisin_count += row.count(raisin)
    end

    if raisin_count < 2 || raisin_count > max_targets
      puts "Помилка! Кількість таргетів повинна бути в діапазоні: 2 <= Кількість < #{max_targets}!"
      return nil
    end

    total_area = matrix.size * matrix.first.size

    if total_area % raisin_count != 0
      puts 'Помилка! Площа не ділиться на кількість таргетів!'
      return nil
    end

    target_area = total_area / raisin_count
    area_dimensions = (1..target_area).select { |i| target_area % i == 0 }

    divide_matrix(matrix, index_raisins(matrix, raisin), area_dimensions.reverse.zip(area_dimensions))
  end



  def self.valid_input?(matrix, raisin, max_targets = 9)
    unless valid_matrix_form?(matrix)
      puts 'Помилка! Матриця має неправильну форму.'
      return false
    end

    if raisin.nil? || raisin.empty?
      puts 'Помилка! Не може бути пустим.'
      return false
    end

    raisin_count = count_raisins(matrix, raisin)

    if raisin_count < 2
      puts 'Помилка! Кількість родзинок повинна бути більше 1.'
      return false
    elsif raisin_count > max_targets
      puts "Помилка! Кількість родзинок не може перевищувати #{max_targets}."
      return false
    end

    true
  end


  def self.valid_matrix_form?(matrix)
    if matrix.nil? || matrix.empty?
      puts 'Матриця порожня або не визначена.'
      return false
    end

    first_row_length = matrix[0].length

    matrix.each do |row|
      if row.nil? || row.length != first_row_length
        puts 'Матриця має неправильну форму.'
        return false
      end
    end

    true
  end


  def self.count_raisins(matrix, raisin)
    return 0 if matrix.nil? || matrix.empty?

    raisin_downcase = raisin.downcase
    count = 0

    matrix.each do |row|
      row.each do |element|
        count += 1 if element.downcase == raisin_downcase
      end
    end

    count
  end


  def self.index_raisins(matrix, raisin)
    indices = []
    matrix.each_with_index do |row, row_idx|
      row.each_with_index do |element, col_idx|
        if element.downcase == raisin.downcase
          indices << [row_idx, col_idx]
        end
      end
    end
    indices
  end


  def self.find_divisors(number, current = 1, divisors = [])
    return divisors if current > number

    if number % current == 0
      divisors << current
    end

    find_divisors(number, current + 1, divisors)
  end


  def self.calculate_square(matrix)
    if matrix.empty?
      puts 'Матриця порожня. Площа не може бути обчислена.'
      return
    end

    rows = matrix.length
    cols = matrix[0].length
    rows * cols
  end


  def self.pick_out_submatrix(matrix, end_position, start_position)
    submatrix = []

    (start_position[0]...end_position[0]).each do |row_idx|
      row = []

      (start_position[1]...end_position[1]).each do |col_idx|
        row << matrix[row_idx][col_idx]
      end

      submatrix << row
    end

    submatrix
  end


  def self.remove_submatrix(matrix, end_position, start_position)
    new_matrix = matrix.map(&:dup)
    (start_position[0]...end_position[0]).each do |i|
      (start_position[1]...end_position[1]).each do |j|
        new_matrix[i][j] = nil
      end
    end
    new_matrix
  end

  def self.divide_matrix(matrix, indices, dimensions, count = indices.length, results = [])
    return results if count < 1

    start = find_first_non_nil(matrix)
    total_area, max_rows, max_cols = matrix_parts(matrix, start)
    current_target = indices[indices.length - count]

    return nil if total_area < dimensions[0][0]

    dimensions.each do |rows, cols|
      if rows <= max_cols && cols <= max_rows && current_target[0] < cols + start[0] && current_target[1] < rows + start[1]
        if square_to_segments(matrix, indices, dimensions, max_rows, max_cols, current_target, start, count, results)
          return results
        end
      end
    end

    nil
  end


  def self.square_to_segments(matrix, indices, dimensions, max_rows, max_cols, current_raisin, start, count, results)
    dimensions.each do |rows, cols|
      if rows > max_cols || cols > max_rows || current_raisin[0] >= cols + start[0] || current_raisin[1] >= rows + start[1]
        next
      end

      if index_in_subregion?(indices, [cols + start[0], rows + start[1]], indices.length - count + 1, start)
        next
      end

      updated_matrix = remove_submatrix(matrix, [cols + start[0], rows + start[1]], start)
      submatrix = pick_out_submatrix(matrix, [cols + start[0], rows + start[1]], start)
      results << submatrix

      if divide_matrix(updated_matrix, indices, dimensions, count - 1, results).nil?
        results.pop
      else
        return results
      end
    end

    nil
  end


  def self.index_in_subregion?(indices, end_position, start_index = 0, start_position = [0, 0])
    indices[start_index..-1].each do |index|
      if index[0] >= start_position[0] && index[0] < end_position[0] &&
        index[1] >= start_position[1] && index[1] < end_position[1]
        return true
      end
    end
    false
  end


  def self.find_first_non_nil(matrix)
    matrix.each_with_index do |row, row_idx|
      first_non_nil_col = row.index { |element| !element.nil? }
      return [row_idx, first_non_nil_col] if first_non_nil_col
    end
    nil
  end

  def self.matrix_parts(matrix, start_position = [0, 0])
    return [0, 0, 0] if matrix.empty? || start_position[0] >= matrix.size || start_position[1] >= matrix[0].size

    rows = matrix.size - start_position[0]
    cols = matrix[start_position[0]].size - start_position[1]

    [rows * cols, rows, cols]
  end

  def self.run
    loop do
      puts 'Меню:'
      puts '1. Розрізати пиріг'
      puts '2. Вихід'
      print 'Виберіть опцію: '
      choice = gets.chomp

      case choice
      when '1'
        puts 'Введіть символ, що позначає родзинки:'
        raisin_char = gets.chomp.strip[0]
        puts 'Введіть кількість рядків у матриці (пиріг):'
        row_count = gets.chomp.to_i

        if row_count < 1 || raisin_char.nil?
          puts 'Помилка! Невірний вхід. Кількість рядків > 0!'
          next
        end

        matrix_input = []
        puts 'Введіть рядки матриці (пирога):'
        row_count.times { matrix_input << gets.chomp.gsub(/\s+/, '').chars }

        split_result = PieCutter.cut(matrix_input, raisin_char)

        if split_result.nil?
          puts 'Помилка! Невірний вхід. Ця матриця не має рішення, перевірте умови, максимальна кількість родзинок = 9!'
          next
        end

        puts 'Результат розподілу пирога з родзинками:'
        result_str = '['

        split_result.each_with_index do |segment, index|
          segment.each { |row| result_str += "\n#{row.join}" }
          result_str += "\n"
          result_str += ',' unless index == split_result.length - 1
        end

        result_str += "\n]"
        puts result_str

      when '2'
        puts 'Програма завершена!'
        break

      else
        puts 'Помилка! Будь ласка, виберіть 1 або 2.'
      end
    end
  end
end

PieCutter.run
