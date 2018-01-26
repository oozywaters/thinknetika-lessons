def fib(limit, memo = [0, 1])
  new_val = memo.last + memo[-2]
  if new_val <= limit
    memo.push(new_val)
    fib(limit, memo)
  end
  memo
end

puts fib(100)
