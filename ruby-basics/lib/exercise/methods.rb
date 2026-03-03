def say_hello
  puts "Hello, World!"
end

def greet(name)
  puts "Hello, #{name}"
end

def greet(name, greeting = "Hello")
  puts "#{greeting}, #{name}"
end

say_hello
greet("Swaraj")
greet("Swaraj", "Hi")
