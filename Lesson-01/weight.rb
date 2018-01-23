puts "Введите Ваше имя:"
name = gets.chomp

puts "Введите Ваш рост:"
height = gets.chomp.to_i

ideal_weight = height - 110

if (ideal_weight > 0)
  puts "Привет, #{name}, твой идеальный вес #{ideal_weight} кг"
else
  puts "Ваш вес уже оптимальный"
end