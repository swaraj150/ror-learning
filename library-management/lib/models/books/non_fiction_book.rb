require_relative '../book'

class NonFictionBook < Book
  attr_accessor :subject, :academic_level

  def initialize(title, author, quantity, subject, academic_level = "general")
    super(title, author, quantity)
    @subject        = subject
    @academic_level = academic_level
  end

  def to_s
    super + "\n  Type: Non-Fiction\n  Subject: #{@subject}\n  Level: #{@academic_level}"
  end
end