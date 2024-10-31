require 'rspec'
require 'csv'
require_relative 'Barbinov_PR5'

RSpec.describe 'Barbinov_PR5' do
  let(:cities) { ENV['CITIES']&.split(',') || [] }
  let(:test_file) { 'weather_data_test.csv' }

  describe '#fetch_weather_data' do
    it 'повертає успішну відповідь для кожного міста' do
      if cities.empty?
        skip "Жодного міста не введено для тестування"
      end

      cities.each do |city|
        data = fetch_weather_data(city)
        expect(data).not_to be_nil
        expect(data['cod']).to eq(200)
      end
    end

    it 'містить необхідні ключі в структурі даних для кожного міста' do
      if cities.empty?
        skip "Жодного міста не введено для тестування"
      end

      cities.each do |city|
        data = fetch_weather_data(city)
        expect(data).to include('name', 'sys', 'main', 'clouds', 'wind', 'weather', 'visibility')
        expect(data['main']).to include('temp', 'humidity', 'pressure')
        expect(data['wind']).to include('speed', 'deg')

        expect(data['name']).to be_a(String)
        expect(data.dig('main', 'temp')).to be_a(Numeric)
        expect(data.dig('main', 'humidity')).to be_a(Integer)
        expect(data.dig('wind', 'speed')).to be_a(Numeric)
        expect(data.dig('weather', 0, 'description')).to be_a(String)
      end
    end
  end

  describe '#save_weather_to_csv' do
    it 'створює файл і додає дані для кожного міста без перезапису' do
      if cities.empty?
        skip "Жодного міста не введено для тестування"
      end

      cities.each do |city|
        data = fetch_weather_data(city)
        save_weather_to_csv(city, test_file)

        csv_data = CSV.read(test_file, headers: true)

        city_data_in_csv = csv_data.find { |row| row['city'].casecmp(city).zero? }
        expect(city_data_in_csv['temp']).to eq("#{data.dig('main', 'temp')}°C")
        expect(city_data_in_csv['humidity']).to eq("#{data.dig('main', 'humidity')}%")
        expect(city_data_in_csv['pressure']).to eq("#{data.dig('main', 'pressure')} hPa")
      end

      expect(File).to exist(test_file)
    end
  end
end
