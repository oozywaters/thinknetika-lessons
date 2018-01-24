def fib(limit)
  x = 0
  y = 1
  limit_reached = false
  fibarray = [0, 1]

  until limit_reached
    y += x
    x = y - x
    fibarray.push(y) if y <= limit
    limit_reached = y >= limit
  end

  fibarray
end

puts fib(100)
