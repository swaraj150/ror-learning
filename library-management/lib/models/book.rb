require_relative '../modules/printable'

class Book
  include Printable

  attr_accessor :title, :author, :quantity
  attr_reader :id

  @@total_books  = 0

  def initialize(title, author, quantity)
    @@total_books  += 1
    @id = @@total_books
    @title = title
    @author = author
    @quantity = quantity
    @available_status = quantity > 0
  end

  def available?
    quantity > 0
  end

  def check_out
    @quantity -= 1
    puts "Enjoy your #{title} book"
  end 
  
  def return_copy
    @quantity += 1
    puts "Thank you for returning your #{title} book"
  end 

  def to_s
    "Book:\n  Title: #{@title}\n  Author: #{@author}\n  Available: #{available?}"
  end

end