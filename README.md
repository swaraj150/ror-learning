# Ruby Learning Journey

A structured repository documenting my implementation of modules in learning planner.
Each section contains exercises and mini-projects built while learning Ruby
in preparation for Ruby on Rails development.

---

## Table of Contents

- [Repository Structure](#repository-structure)
- [Library Management System](#library-management-system)
- [Book Catalog App](#book-catalog-app)
- [Task Manager App](#task-manager-app)
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
| 
├── task_manager/               
|  
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
## Task Manager App
### Database Models

#### Users
| Column | Type |
|--------|------|
| id | integer | 
| name | string | 
| email | string |
| password_digest | string | 
| created_at | datetime | 
| updated_at | datetime |

#### Tasks
| Column | Type | 
|--------|------|
| id | integer | 
| title | string | 
| description | text | 
| status | string |
| priority | integer | 
| due_date | datetime | 
| user_id | integer | 
| created_at | datetime | 
| updated_at | datetime | 

#### Associations
- A **User** has many **Tasks** (`has_many :tasks, dependent: :destroy`)
- A **Task** belongs to a **User** (`belongs_to :user`)
---
### API Endpoints
 
All task endpoints are nested under users — a task always belongs to a user.
 
#### Users
 
| Method | Endpoint       | Description       |
|--------|----------------|-------------------|
| GET    | /users         | Get all users     |
| GET    | /users/:id     | Get a user        |
| POST   | /users         | Create a user     |
| PATCH  | /users/:id     | Update a user     |
| DELETE | /users/:id     | Delete a user     |
 
#### Tasks (nested under Users)
 
| Method | Endpoint                        | Description          |
|--------|---------------------------------|----------------------|
| GET    | /users/:user_id/tasks           | Get all tasks for user |
| GET    | /users/:user_id/tasks/:id       | Get a task           |
| POST   | /users/:user_id/tasks           | Create a task        |
| PATCH  | /users/:user_id/tasks/:id       | Update a task        |
| DELETE | /users/:user_id/tasks/:id       | Delete a task        |
 
---
 
### Test Structure
```
spec/
├── rails_helper.rb
├── spec_helper.rb
├── factories/
│   ├── users.rb
│   └── tasks.rb
├── models/
│   ├── user_spec.rb
│   └── task_spec.rb
├── requests/
│   ├── users_spec.rb
│   └── tasks_spec.rb
└── support/
    └── database_cleaner.rb
```
---

## Roadmap

- ✅ Ruby fundamentals
- ✅ Ruby OOP and collections
  - ✅ Library Management System
- ✅ TDD with Ruby and Rspec
  - ✅ Leap year kata
  - ✅ String calculator kata
- ✅ Rails MVC setup and first rails app
  - ✅ Book Catalog App
- ✅ Active Record Database & Migrations
  - ✅ intialized Task Manager App with models and associations
- ✅ Rails Testing with RSpec & FactoryBot
  - ✅ Add model validations and define routes and controller methods for User and Task models
  - ✅ Test model validations and associations for User and Task
  - ✅ Test Http response and status codes for endpoints

