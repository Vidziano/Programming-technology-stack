def find_raisins(cake)
  raisins = []
  cake.each_with_index do |row, r_index|
    row.chars.each_with_index do |cell, c_index|
      raisins << [r_index, c_index] if cell == 'o'
    end
  end
  raisins
end

def create_piece(cake, start_row, end_row, start_col, end_col)
  piece = []
  (start_row..end_row).each do |r|
    piece << cake[r][start_col..end_col]
  end
  piece
end

def horizontal_slicing(cake, target_area, raisins)
  pieces = []
  current_area = 0
  start_row = 0
  start_col = 0

  raisins.each do |r_index, c_index|
    if pieces.size < raisins.size - 1
      end_row = r_index
      end_col = cake[r_index].length - 1
      piece = create_piece(cake, start_row, end_row, start_col, end_col)
      pieces << piece
      current_area += piece.size * piece[0].length
      start_row = end_row + 1
    end
  end

  end_row = cake.size - 1
  end_col = cake[end_row].length - 1
  pieces << create_piece(cake, start_row, end_row, start_col, end_col)

  pieces
end

def vertical_slicing(cake, target_area, raisins)
  pieces = []
  rows = cake.length
  cols = cake[0].length

  # Розрізаємо вертикально
  (0...cols).each do |c_index|
    piece = []
    current_area = 0

    raisins.each do |r_index, _|
      if piece.size < raisins.size - 1
        # Розрізаємо стовпець
        piece << (0...rows).map { |r| cake[r][c_index] }.join
        current_area += 1

        if current_area == target_area
          pieces << piece
          piece = []
          current_area = 0
        end
      end
    end
  end

  pieces
end

def slice_cake(cake)
  raisins = find_raisins(cake)
  n = raisins.size
  return [] if n < 2 || n >= 10

  total_area = cake.size * cake[0].length
  target_area = total_area / n

  horizontal_pieces = horizontal_slicing(cake, target_area, raisins)

  vertical_pieces = vertical_slicing(cake, target_area, raisins)

  if horizontal_pieces.size >= n
    return horizontal_pieces.first(n)
  elsif vertical_pieces.size >= n
    return vertical_pieces.first(n)
  end

  []
end

examples = [
  [
    "........",
    "..o.....",
    "...o....",
    "........"
  ],
  [
    ".o......",
    "......o.",
    "....o...",
    "..o....."
  ],
  [
    ".o.о....",
    "........",
    "....o...",
    "........",
    ".....o..",
    "........"
  ]
]

examples.each_with_index do |cake, index|
  result = slice_cake(cake)
  puts "Результат для прикладу #{index + 1}:"

  result.each_with_index do |piece, piece_index|
    puts "Шматок #{piece_index + 1}:"
    puts piece.join("\n")
    puts ""
  end

  puts "\n"
end