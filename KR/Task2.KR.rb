class BankAccount
  def initialize(initial_balance = 0)
    @balance = initial_balance
  end

  def balance
    @balance
  end

  def deposit(amount)
    if amount > 0
      @balance += amount
      puts "Ви внесли #{amount} грн на рахунок."
    else
      puts "Сума некоректна!"
    end
  end

  def withdraw(amount)
    if amount > 0 && amount <= @balance
      @balance -= amount
      puts "Ви зняли #{amount} грн з рахунку. Поточний баланс: #{@balance} грн."
    elsif amount > @balance
      puts "Недостатньо коштів на рахунку!"
    else
      puts "Сума некоректна!"
    end
  end
end

def menu(account)
  loop do
    puts "\n-------------------------------"
    puts "Меню:"
    puts "1. Перевірити баланс"
    puts "2. Внести гроші"
    puts "3. Зняти гроші"
    puts "4. Вихід"
    puts "\n-------------------------------"
    print "Оберіть опцію: "

    choice = gets.chomp.to_i

    case choice
    when 1
      puts "Ваш поточний баланс: #{account.balance} грн."
    when 2
      print "Введіть суму для внесення: "
      amount = gets.chomp.to_f
      account.deposit(amount)
    when 3
      print "Введіть суму для зняття: "
      amount = gets.chomp.to_f
      account.withdraw(amount)
    when 4
      puts "До побачення!"
      break
    else
      puts "Невірний вибір, спробуйте знову."
    end
  end
end

# Запитуємо в користувача, чи хоче він вказати початковий баланс
puts "Бажаєте вказати початковий баланс? (так/ні)"
initial_balance_choice = gets.chomp.downcase

if initial_balance_choice == "так"
  print "Введіть початковий баланс: "
  initial_balance = gets.chomp.to_f
  account = BankAccount.new(initial_balance)
else
  account = BankAccount.new # Створюємо рахунок без початкового балансу (0 грн)
end

menu(account)
