# map
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

doubled = numbers.map do |n|
  n*2
end

squared = numbers.map { |n| n**2 }

words = numbers.map do |n|
  "hello" + n.to_s
end

puts doubled.inspect
puts squared.inspect
puts words.inspect


# select and reject

evens = numbers.select { |n| n.even?}

odds = numbers.reject { |n| n % 2 == 0 }

puts evens.inspect
puts odds.inspect
