class Book
  attr_accessor :title, :author, :quantity
  attr_reader :id

  @@total_count  = 0

  def initialize(title, author, available_status, quantity)
    @@total_count  += 1
    @id = @@total_count
    @title = title
    @author = author
    @available_status = available_status
    @quantity = quantity
  end

  def available?
    @available_status
  end

  def check_out
    unless @available_status 
      puts "Sorry, '#{@title}' is not available."
      return
    end

    @quantity -= 1
    @available_status = false if @quantity.zero?

    puts "Enjoy your #{title} book"
  end 

  def to_s
    "Book:\n  Title: #{@title}\n  Author: #{@author}\n  Available: #{available?}"
  end

        
end