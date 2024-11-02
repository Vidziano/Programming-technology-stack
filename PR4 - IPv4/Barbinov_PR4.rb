class IPAddressValidator
  def self.main(args)

    for ip in args
      if ip.empty?
        puts "Empty string is not a valid IP address"
        next
      end

      if ip.strip != ip || ip =~ /\s/
        puts "#{ip} false, because it contains leading/trailing or internal spaces"
        next
      end

      if ip !~ /^[0-9.]+$/
        puts "#{ip} false, because it contains invalid characters"
        next
      end

      octets = ip.split('.')

      empty_octet_found = false
      if ip.start_with?('.') || ip.end_with?('.') || ip.include?('..')
        empty_octet_found = true
      else
        octets.each do |octet|
          if octet.empty?
            empty_octet_found = true
            break
          end
        end
      end

      if empty_octet_found
        puts "#{ip} false, because it contains empty octets without numbers"
        next
      end

      for octet in octets
        if octet !~ /^\d+$/
          puts "#{ip} false, because it contains octet with non-numeric characters"
          error = true
          break
        end

        if octet.length > 1 && octet.start_with?('0')
          puts "#{ip} false, because it contains octet with leading zeros"
          error = true
          break
        end

        octet_int = octet.to_i
        if octet_int < 0 || octet_int > 255
          puts "#{ip} false, because it contains octet #{octet_int} out of range 0-255"
          error = true
          break
        end
      end

      if octets.length != 4
        puts "#{ip} false, because it contains #{octets.length} octets, but it must contain exactly 4"
        next
      end

      puts "#{ip} true" unless error
    end
  end
end


ip_addresses_to_test = [
  "192.168.1.1",            # Валідні IP
  "0.0.0.0",
  "255.255.255.255",
  "0.254.138.1",
]

puts "-------------------------------------------------------------------------"
IPAddressValidator.main(ip_addresses_to_test)

puts "-------------------------------------------------------------------------"
# Ведучі нулі
ip_addresses_to_test = [
  "192.168.001.1",          # Ведучі нулі
  "192.168.01.1",
  "192.168.1.01",
  "123.045.67.89",
  "0.0.0.00",
]
IPAddressValidator.main(ip_addresses_to_test)

puts "-------------------------------------------------------------------------"

ip_addresses_to_test = [
  "256.100.50.25",          # Октет поза діапазоном
  "192.168.1.256",
]
IPAddressValidator.main(ip_addresses_to_test)

puts "-------------------------------------------------------------------------"
# Неприпустимі символи
ip_addresses_to_test = [
  "192.168.1.a",            # Неприпустимі символи
  "abc.def.ghi.jkl",
]
IPAddressValidator.main(ip_addresses_to_test)

puts "-------------------------------------------------------------------------"
# Порожні октети
ip_addresses_to_test = [
  "172.16..1",             # Порожній октет
  "172..254.1",
  "172...1",
  ".16.254.1",
  "172.16.254.",
  "...",

]
IPAddressValidator.main(ip_addresses_to_test)

puts "-------------------------------------------------------------------------"
ip_addresses_to_test = [
  "192.168.50.1.1",          # Зайві октети
  "192.168.50",              # Недостатньо октетів
]
IPAddressValidator.main(ip_addresses_to_test)

puts "-------------------------------------------------------------------------"
ip_addresses_to_test = [
  "",                       # Порожній рядок
]
IPAddressValidator.main(ip_addresses_to_test)

puts "-------------------------------------------------------------------------"
ip_addresses_to_test = [
  "192. 168.50.1",           # Пробіл всередині
  " 192.168.50.1",           # Пробіл на почтаку
  "192.168.50.1 ",           # Пробіл в кінці

]
IPAddressValidator.main(ip_addresses_to_test)
