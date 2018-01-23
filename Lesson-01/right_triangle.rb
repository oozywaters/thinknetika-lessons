puts "Введите длину стороны a"
a = gets.chomp.to_i

puts "Введите длину стороны b"
b = gets.chomp.to_i

puts "Введите длину стороны с"
c = gets.chomp.to_i

sides = [a, b, c]

hypothenuse = sides.max
sides.delete_at(sides.index hypothenuse)

cathet1 = sides[0]
cathet2 = sides[1]

if hypothenuse**2 == cathet1**2 + cathet2**2
  output_str = "Ваш треугольник прямоугольный"
  output_str += " и равнобедренный" if cathet1 == cathet2
  puts output_str
elsif [a, b, c].uniq.size == 1
  puts "Ваш треугольник равносторонний"
else
  puts "Ваш треугольник не прямоугольный"
end