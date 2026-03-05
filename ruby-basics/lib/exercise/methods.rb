# Methods

# Basic method with no parameters
def say_hello
  puts "Hello, World!"
end

# Method with a required parameter
def greet(name)
  puts "Hello, #{name}"
end

# Method with a default argument
def greet(name, greeting = "Hello")
  puts "#{greeting}, #{name}"
end

say_hello
greet("Swaraj")
greet("Swaraj", "Hi")
