def fib(limit)
  prev_value = 0
  next_value = 1
  limit_reached = false
  fibarray = [0, 1]

  until limit_reached
    current_value = next_value
    next_value += prev_value
    prev_value = current_value
    if next_value > limit
      limit_reached = true
    else
      limit_reached = next_value == limit
      fibarray.push(next_value)
    end
  end

  fibarray
end

puts fib(100)
