# arrays
colors = ["red", "green", "blue", "yellow", "purple"]
puts colors[0]
puts colors[-1]
puts colors[1..3].inspect # (index 1 to 3) included
puts colors[0, 2].inspect # (start, count)

colors.push("black")
colors << "orange" # << is shorthand for push
colors.unshift("white") # add to front
puts colors.inspect

colors.pop # remove from end
colors.shift # remove from front

puts colors.inspect

nums = [3, 1, 4, 1, 5, 9, 2, 6]
puts nums.sort.uniq.inspect
puts nums.sum
puts nums.max
puts nums.select { |n| n > 5}.sort.inspect
puts nums.map { |n| n * 2}.select { |n| n > 5}.sort.inspect
