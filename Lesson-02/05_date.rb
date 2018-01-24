puts "Введите число (день):"
day = gets.chomp.to_i

puts "Введите порядковый номер месяца:"
month = gets.chomp.to_i - 1

puts "Введите год:"
year = gets.chomp.to_i

def leap_year?(year)
  (year % 4 == 0) && !(year % 100 == 0) || (year % 400 == 0)
end

days_count = 0
number_of_days = [31, (leap_year?(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
is_correct_date = number_of_days[month] && day > 0 && day <= number_of_days[month]

if is_correct_date
  number_of_days.first(month).each { |n| days_count += n}
  days_count += day
  month_str = (month + 1).to_s.rjust(2, '0')
  puts "#{day}.#{month_str}.#{year} - это #{days_count}-й день в году"
else
  puts "Вы ввели неправильную дату!"
end
