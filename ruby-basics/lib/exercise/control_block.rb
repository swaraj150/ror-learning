score = 85

if score >= 90
  puts "A"
elsif score >= 80
  puts "B"
else
  puts "C"
end



logged_in = false

unless logged_in
  puts "Please log in"
end

puts "Please log in" unless logged_in



day = "Monday"

case day
when "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"
  puts "Weekday"
when "Saturday", "Sunday"
  puts "Weekend"
else
  puts "empty"
end
