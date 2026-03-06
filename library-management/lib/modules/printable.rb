module Printable
  def print_summary
    puts to_s
  end

  def print_details
    puts "=" * 40
    puts to_s
    puts "=" * 40
  end
end