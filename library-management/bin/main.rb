require_relative '../lib/library'

lib = Library.new

lib.add_fiction_book("Dune", "Frank Herbert", 3, "sci-fi")
lib.add_fiction_book("1984", "George Orwell", 2, "dystopia", "16+")
lib.add_non_fiction_book("Sapiens", "Yuval Harari", 4, "history")

lib.register_member("Alice")
lib.register_member("Bob")

lib.borrow_book(1, 1)
lib.borrow_book(2, 1)
lib.return_book(1, 1)

results = lib.search_by_title("dune")
results.each(&:print_details)
