puts "Введите коэффициент a"
a = gets.chomp.to_i

puts "Введите коэффициент b"
b = gets.chomp.to_i

puts "Введите коэффициент с"
c = gets.chomp.to_i

d = b**2 - 4 * a * c

if d > 0
  puts "Дискриминант: #{d}"
  sqrt_d = Math.sqrt(d)
  x1 = (-b + sqrt_d) / (2 * a)
  x2 = (-b - sqrt_d) / (2 * a)
  puts "Корень 1: #{x1}"
  puts "Корень 2: #{x2}"
elsif d == 0
  puts "Дискриминант: #{d}"
  puts "Корень уравнения: #{-b / (2 * a)}"
elsif d < 0
  puts "Дискриминант: #{d}"
  puts "Корней нет!"
end