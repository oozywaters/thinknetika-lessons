stop = false
purchases = {}

until stop
  puts "Введите название товара:"
  name = gets.chomp.downcase

  if name == 'stop'
    stop = true
    break
  end

  puts "Введите цену товара:"
  price = gets.chomp.to_f

  puts "Введите количество товара:"
  qty = gets.chomp.to_f

  purchases[name.to_sym] = { price: price, quantity: qty, sum: price * qty}
end

total_amount = purchases.inject(0) { |sum, (_key, value)| sum + value[:sum]}
puts purchases
puts "Итоговая сумма покупок составляет: #{total_amount}"
