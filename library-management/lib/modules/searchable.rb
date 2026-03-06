module Searchable
  def search_by_title(title)
    @books.values.select { |book| book.title.downcase.include?(title.downcase) }
  end

  def search_by_author(author)
    @books.values.select { |book| book.author.downcase.include?(author.downcase) }
  end

  def search_by_type(type)
    @books.values.select { |book| book.is_a?(type) }
  end
end