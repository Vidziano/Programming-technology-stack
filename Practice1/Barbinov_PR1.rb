# Лічильники
user_wins = 0
opponent_wins = 0

def get_opponent_choice
  %w[камінь ножиці папір].sample
end

def determine_winner(user_choice, opponent_choice)
  if user_choice == opponent_choice
    "Нічия"
  elsif (user_choice == "камінь" && opponent_choice == "ножиці") ||
    (user_choice == "ножиці" && opponent_choice == "папір") ||
    (user_choice == "папір" && opponent_choice == "камінь")
    "Користувач"
  else
    "Суперник"
  end
end

print "-----------------------------------------------------------------------------\n"
puts "Правила гри:\nКамінь б'є Ножиці\nНожиці б'ють Папір\nПапір б'є Камінь"

loop do
  print "-----------------------------------------------------------------------------\n"
  puts "Оберіть:\n1. Камінь\n2. Ножиці\n3. Папір\n4. Вихід з гри"
  print "-----------------------------------------------------------------------------\n"
  print "=>"
  choice = gets.chomp.to_i

  case choice
  when 1
    user_choice = "камінь"
  when 2
    user_choice = "ножиці"
  when 3
    user_choice = "папір"
  when 4
    break
  else
    puts "Невірний вибір. Спробуйте ще раз."
    next
  end

  puts "Ваш вибір: #{user_choice}"
  opponent_choice = get_opponent_choice
  puts "Вибір суперника: #{opponent_choice}"

  winner = determine_winner(user_choice, opponent_choice)
  case winner
  when "Користувач"
    user_wins += 1
    puts "Ви виграли! :) "
  when "Суперник"
    opponent_wins += 1
    puts "Суперник виграв :( "
  else
    puts "Нічия!"
  end
  print "-----------------------------------------------------------------------------\n"
  puts "Рахунок:\nВи: #{user_wins}\nСуперник: #{opponent_wins}"
end

# Визначення переможця
if user_wins > opponent_wins
  puts "Вітаємо з перемогою! Ти розірвав суперника на шматки!"
elsif opponent_wins > user_wins
  puts "Ой-ой, цього разу ти програв, але не впадай у відчай — розпочни новий раунд!"
else
  puts "Нічия! Гарна гра!"
end

puts "Фінальний рахунок: #{user_wins}:#{opponent_wins}"
print "-----------------------------------------------------------------------------"
