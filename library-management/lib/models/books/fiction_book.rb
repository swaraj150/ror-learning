require_relative '../book'

class FictionBook < Book
  attr_accessor :genre, :age_rating

  def initialize(title, author, quantity, genre, age_rating = "all ages")
    super(title, author, quantity)       # calls Book's initialize
    @genre      = genre
    @age_rating = age_rating
  end

  def to_s
    super + "\n  Type: Fiction\n  Genre: #{@genre}\n  Age Rating: #{@age_rating}"
  end
end