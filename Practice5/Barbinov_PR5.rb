require 'net/http'
require 'json'
require 'csv'
require 'uri'

API_KEY = 'e0cfeb8ae5e3f14a48cc858f312808d7'
BASE_URL = 'http://api.openweathermap.org/data/2.5/weather'

def fetch_weather_data(city)
  encoded_city = URI.encode_www_form_component(city)
  url = "#{BASE_URL}?q=#{encoded_city}&appid=#{API_KEY}&units=metric"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)

  if data['cod'] != 200
    puts "Помилка: #{data['message'].capitalize}. Перевірте назву міста і спробуйте знову."
    return nil
  end

  data
end

def save_weather_to_csv(city, file_name = 'weather_data_selected.csv')
  data = fetch_weather_data(city)
  return if data.nil?

  weather_info = {
    time: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
    city: data['name'],
    country: data.dig('sys', 'country'),
    temp: "#{data.dig('main', 'temp')}°C",
    clouds: "#{data.dig('clouds', 'all')}%",
    humidity: "#{data.dig('main', 'humidity')}%",
    pressure: "#{data.dig('main', 'pressure')} hPa",
    wind_direction: "#{data.dig('wind', 'deg')}°",
    wind_speed: "#{data.dig('wind', 'speed')} m/s",
    weather_description: data.dig('weather', 0, 'description').capitalize,
    visibility: "#{data['visibility']} m"
  }

  file_exists = File.exist?(file_name)

  CSV.open(file_name, "a+", write_headers: !file_exists, headers: weather_info.keys) do |csv|
    csv << weather_info.values
  end

  puts "Дані для #{city} успішно збережені в файл #{file_name}."
end

def run_tests(cities_for_test)
  if cities_for_test.empty?
    puts "Усі введені міста вже протестовані. Введіть нові міста для тестування."
  else
    ENV['CITIES'] = cities_for_test.join(',')
    system("rspec C:/Projects/Practice5/Test_Weather.rb")
  end
end

def main_menu
  cities_for_test = []

  loop do
    puts "\nМеню:"
    puts "1. Ввести назву міста"
    puts "2. Запустити тести"
    puts "3. Завершити"
    print "Оберіть опцію: "
    choice = gets.chomp

    case choice
    when "1"
      print "Введіть назву міста: "
      city = gets.chomp
      save_weather_to_csv(city)
      cities_for_test << city
    when "2"
      if cities_for_test.empty?
        puts "Не введено нових міст для запуску тестів. Будь ласка, введіть хоча б одне нове місто перед запуском тестів."
      else
        puts "Запускаємо тести для нових міст!"
        run_tests(cities_for_test)
        cities_for_test.clear
        puts "\nТести завершено. Ви можете продовжити введення міст."
      end
    when "3"
      puts "Вихід із програми. До побачення!"
      break
    else
      puts "Невірний вибір. Спробуйте знову."
    end
  end
end

main_menu if __FILE__ == $0
