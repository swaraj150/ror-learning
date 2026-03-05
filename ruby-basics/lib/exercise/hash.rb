# Hashes

# Creating and Accessing a Hash
person = {
  name: "Swaraj",
  age: 25,
  job: "Developer"
}

puts person[:name]
puts person[:age]    

person[:hobby] = "Football"
puts person[:hobby]

puts person.keys.inspect
puts person.values.inspect


# Iterating Over a Hash
scores = {
  a: 92,
  b: 78,
  c: 85,
  d: 91
}

scores.each do |name, score|
  puts "#{name}: #{score}"
end

puts scores.values.max

# Array of Hashes
students = [
  { name: "a", grade: 90 },
  { name: "b",   grade: 72 },
  { name: "c", grade: 88 },
  { name: "d",  grade: 65 }
]

students.each do |student|
  puts student[:name]
end

# Filter students who passed (grade >= 70), then extract their names
passed = students.select { |s| s[:grade] >= 70 }
puts passed.map { |s| s[:name] }.inspect