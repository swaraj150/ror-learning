require_relative 'models/book'
require_relative 'models/books/fiction_book'
require_relative 'models/books/non_fiction_book'
require_relative 'models/member'
require_relative 'modules/searchable'
class Library
  include Searchable
  def initialize
    @books   = {}
    @members = {}
  end

  def add_book(title,author,quantity)
    book = Book.new(title,author,quantity)
    @books[book.id] = book
  end

  def add_fiction_book(title, author, quantity, genre, age_rating = "all ages")
    book = FictionBook.new(title, author, quantity, genre, age_rating)
    @books[book.id] = book
  end

  def add_non_fiction_book(title, author, quantity, subject, level = "general")
    book = NonFictionBook.new(title, author, quantity, subject, level)
    @books[book.id] = book
  end

  def register_member(name)
    member = Member.new(name)
    @members[member.id] = member
  end

  def get_member(member_id)
    member = @members[member_id]
    
    if member.nil?
      raise "Member with ID #{member_id} not found."
    end
    
    return member
  end
  def get_book(book_id)
    book = @books[book_id]
    
    if book.nil?
      raise "Book with ID #{book_id} not found."
    end

    return book
  end

  def borrow_book(member_id, book_id)
    member = get_member(member_id)
    book   = get_book(book_id)

    if book.available?
      member.borrow_book(book_id)
      book.check_out
    else
      puts "Sorry, '#{book.title}' is currently unavailable."
    end
  end

  def return_book(member_id, book_id)
    member = get_member(member_id)
    book   = get_book(book_id)

    member.return_book(book_id)
    book.return_copy
  end

  def list_available_books
    available = @books.values.select(&:available?)
    if available.empty?
      puts "No books currently available."
    else
      available.each(&:print_summary)
    end
  end
end
