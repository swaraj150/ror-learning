# Ruby Learning Journey

A structured repository documenting my Ruby fundamentals and OOP concepts.
Each section contains exercises and mini-projects built while learning Ruby
in preparation for Ruby on Rails development.

---

## Table of Contents

- [Repository Structure](#repository-structure)
- [Resources](#resources)
- [Roadmap](#roadmap)

---

## Repository Structure
```
.
├── ruby-basics/                    # Day 1 — fundamentals exercises  
│
├── library-management/             # Day 2 — OOP mini project
│   ├── bin/
│   │   └── main.rb                 # entry point
│   └── lib/
│       ├── library.rb
│       ├── models/
│       │   ├── book.rb
│       │   ├── member.rb
│       │   ├── books/
│       │       ├── fiction_book.rb
│       │       ├── non_fiction_book.rb   
│       └── modules/
│           ├── searchable.rb
│           ├── printable.rb
│
└── README.md
```

### Mini Project: Library Management System

A working library system demonstrating OOP design principles in Ruby.

#### Class Hierarchy
```
Book
├── FictionBook       # adds genre, age rating
├── NonFictionBook    # adds subject, academic level

Member

Library               # owns books and members, handles all operations
```

#### Modules

| Module | Mixed Into | Responsibility |
|---|---|---|
| `Searchable` | Library | Search by title, author, type |
| `Printable` | Book, Member | `print_summary`, `print_details` |

#### Example Usage
```ruby
library = Library.new

# add books
library.add_fiction_book("Dune", "Frank Herbert", 3, "sci-fi")
library.add_non_fiction_book("Sapiens", "Yuval Harari", 4, "history")

# register members
library.register_member("Alice")
library.register_member("Bob")

# borrow and return
library.borrow_book(1, 1)
library.return_book(1, 1)

# search
results = library.search_by_title("dune")
results.each(&:print_details)
```

---

## Roadmap

- [x] Ruby fundamentals
- [x] Ruby OOP and collections
- [x] Library Management System
