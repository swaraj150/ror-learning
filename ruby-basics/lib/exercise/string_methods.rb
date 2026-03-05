# Strings 
first = "hello"

second = first

puts first * 3 + " " + second
puts first.length
puts first.upcase
puts first.reverse
puts first.include?("ell")
puts first.capitalize
puts first.gsub("e","h") #replace
puts first.upcase.reverse

# Bang method (mutates the original object in place)
puts first.upcase!  # Changes from "hello" to "HELLO" permanently 
puts second # HELLO instead of hello
