# Ruby Learning Journey

A structured repository documenting my implementation of modules in learning planner.
Each section contains exercises and mini-projects built while learning Ruby
in preparation for Ruby on Rails development.

---

## Table of Contents

- [Repository Structure](#repository-structure)
- [Library Management System](#library-management-system)
- [Book Catalog App](#book-catalog-app)
- [Roadmap](#roadmap)

---

## Repository Structure
```
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
|── tdd-ruby/                       # Day 3 - TDD with Rspec
|   |── lib/
|   |   |── leap_year.rb
|   |   |── string_calculator.rb
|   └── spec/
|       ├── leap_year_spec.rb
|       ├── string_calculator_spec.rb
|       ├── spec_helper.rb
|
├── book-catalog-app/               # Day 4 - Rails Setup MVC & First Rails App                     
└── README.md
```

## Library Management System

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
## Book Catalog App

#### Books List

<img width="1918" height="961" alt="image" src="https://github.com/user-attachments/assets/a927537a-e4ab-48a6-89cb-595cba116628" />

#### Book Details

<img width="1913" height="962" alt="image" src="https://github.com/user-attachments/assets/29579926-71a3-4d25-a3bb-01bfd6de1261" />

---

## Roadmap

- [x] Ruby fundamentals
- [x] Ruby OOP and collections
  - [x] Library Management System
- [x] TDD with Ruby and Rspec
  - [x] Leap year kata
  - [x] String calculator kata
- [x] Rails MVC setup and first rails app
  - [x] Book Catalog App
