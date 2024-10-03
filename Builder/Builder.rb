class GameCharacter
  def initialize
    @skills = []
  end
  
  def name
    @name
  end

  def name=(value)
    @name = value
  end

  def character_class
    @character_class
  end

  def character_class=(value)
    @character_class = value
  end

  def weapon
    @weapon
  end

  def weapon=(value)
    @weapon = value
  end

  def armor
    @armor
  end

  def armor=(value)
    @armor = value
  end

  def level
    @level
  end

  def level=(value)
    @level = value
  end

  def skills
    @skills
  end

  def skills=(value)
    @skills = value
  end

  def display
    puts "Ім'я: #{@name}"
    puts "Клас: #{@character_class}"
    puts "Зброя: #{@weapon}"
    puts "Броня: #{@armor}"
    puts "Рівень: #{@level}"
    puts "Навички: #{@skills.join(', ')}"
  end
end

# Builder для створення персонажа
class GameCharacterBuilder
  def initialize
    @character = GameCharacter.new
  end

  def set_name(name)
    @character.name = name
    self
  end

  def set_character_class(character_class)
    @character.character_class = character_class
    self
  end

  def set_weapon(weapon)
    @character.weapon = weapon
    self
  end

  def set_armor(armor)
    @character.armor = armor
    self
  end

  def set_level(level)
    @character.level = level
    self
  end

  def add_skill(skill)
    @character.skills << skill
    self
  end

  # Метод для отримання готового об'єкта
  def build
    @character
  end
end

# Директор керує будівельником для створення конкретних персонажів
class GameCharacterDirector
  def initialize(builder)
    @builder = builder
  end

  def construct_warrior
    @builder.set_name('Артур')
            .set_character_class('Воїн')
            .set_weapon('Меч')
            .set_armor('Тяжка броня')
            .set_level(10)
            .add_skill('Сильний удар')
            .add_skill('Щит')
            .build
  end

  def construct_mage
    @builder.set_name('Мерлін')
            .set_character_class('Маг')
            .set_weapon('Чарівна паличка')
            .set_armor('Мантия')
            .set_level(8)
            .add_skill('Вогняна куля')
            .add_skill('Лікування')
            .build
  end
end

# Використання будівельника та директора
builder = GameCharacterBuilder.new
director = GameCharacterDirector.new(builder)

# Створюємо воїна
warrior = director.construct_warrior
warrior.display

puts '--------------------------------------------------------'

# Створюємо мага
mage = director.construct_mage
mage.display
