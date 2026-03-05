# arrays
colors = ["red", "green", "blue", "yellow", "purple"]

# Accessing elements
puts colors[0]
puts colors[-1]
puts colors[1..3].inspect # (index 1 to 3) included
puts colors[0, 2].inspect # (start, count)

# Adding elements
colors.push("black")
colors << "orange" # << is shorthand for push
colors.unshift("white") # add to front
puts colors.inspect


# Removing elements
colors.pop # remove from end
colors.shift # remove from front
puts colors.inspect

# Sorting, filtering, and transforming
nums = [3, 1, 4, 1, 5, 9, 2, 6]
puts nums.sort.uniq.inspect # sort and remove duplicates
puts nums.sum
puts nums.max
puts nums.select { |n| n > 5}.sort.inspect # filter elements > 5, then sort
puts nums.map { |n| n * 2}.select { |n| n > 5}.sort.inspect # double each, filter > 5, sort
