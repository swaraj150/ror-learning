require 'date'

class Member

  attr_writer :name
  attr_reader :id, :join_date, :borrowed_books

  @@total_users = 0

  def initialize(name)
    @@total_users += 1
    @id = @@total_users
    @name = name
    @join_date = Date.today
    @borrowed_books = []
  end

  def borrow_book(book_id)
    if @borrowed_books.include?(book_id)
      raise "You've already borrowed this book."
    end

    @borrowed_books << book_id
  end

  def return_book(book_id)
    unless @borrowed_books.include?(book_id)
      raise "Member '#{name}' hasn't borrowed this book."
    end
    @borrowed_books.delete(book_id)
  end
end
  

