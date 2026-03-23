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
### Authentication

Authentication is handled by **Devise** with **JWT tokens**.

#### Flow
1. User registers via `POST /users`
2. User logs in via `POST /users/sign_in` — receives access token and refresh token
3. Access token is sent on every request via `Authorization: Bearer <token>` header
4. When access token expires, use `POST /users/refresh` with refresh token to get a new one
5. Logout via `DELETE /users/sign_out` — clears refresh token from database

#### Token details

| Token | Expiry | Storage |
|---|---|---|
| Access token | 24 hours | Client only |
| Refresh token | 30 days | Client + Database |

---

### Authorization

- All task endpoints are scoped to the authenticated user via `current_user`
- Users can only access and modify their own tasks — cross-user access returns 404
- Role-based access control via `enum :role, { user: 0, admin: 1 }`
- Admin-only endpoints protected with `require_admin!` helper

---

### API Endpoints

#### Auth

| Method | Endpoint | Auth required | Description |
|--------|----------|---------------|-------------|
| POST | /users | No | Register |
| POST | /users/sign_in | No | Login — returns tokens |
| DELETE | /users/sign_out | Yes | Logout — clears refresh token |
| POST | /users/refresh | Yes (refresh token) | Get new access token |
| PATCH | /users | Yes | Update account |
| DELETE | /users | Yes | Delete account |

#### Users

| Method | Endpoint | Auth required | Description |
|--------|----------|---------------|-------------|
| GET | /users | Yes (admin) | Get all users |
| GET | /users/:id | Yes | Get a user |

#### Tasks

| Method | Endpoint | Auth required | Description |
|--------|----------|---------------|-------------|
| GET | /tasks | Yes | Get all tasks for current user |
| GET | /tasks/:id | Yes | Get a task |
| POST | /tasks | Yes | Create a task |
| PATCH | /tasks/:id | Yes | Update a task |
| DELETE | /tasks/:id | Yes | Delete a task |

#### Query Parameters (GET /tasks)
 
| Parameter | Type | Description | Example |
|---|---|---|---|
| `status` | string | Filter by status | `?status=todo` |
| `priority` | string | Filter by priority | `?priority=high` |
| `search` | string | Search by title | `?search=rails` |
| `sort` | string | Sort field | `?sort=due_date` |
| `order` | string | Sort direction | `?order=asc` |
| `page` | integer | Page number | `?page=2` |
| `per_page` | integer | Items per page | `?per_page=20` |
---

---
 
## Docker
 
### Services
 
| Service | Image | Port |
|---|---|---|
| app | custom (Rails) | 3000 |
| db | postgres:15 | 5432 |
| redis | redis:7-alpine | 6379 |
| sidekiq | custom (Rails) | — |

### Common Commands
 
```bash
# start all services
docker compose up --build
 
# start in background
docker compose up -d
 
# view logs
docker compose logs -f app
docker compose logs -f sidekiq
 
# stop everything
docker compose down
 
# wipe all data and start fresh
docker compose down -v && docker compose up --build
 
# run one-off command
docker compose exec app bundle exec rails console
docker compose exec app bundle exec rails db:seed
```

### Build Production Image
 
```bash
docker build -t task-manager-api .
```
 
---
 
## Deployment
 
The app is deployed on **Render** using Docker.
 
### Services on Render
 
| Service | Type | Plan |
|---|---|---|
| task-manager-api | Web Service | Free |
| task-manager-db | PostgreSQL | Free |
| task-manager-redis | Key Value (Redis) | Free |
 
### Required Environment Variables on Render
 
```
RAILS_ENV=production
RAILS_MASTER_KEY=<contents of config/master.key>
RAILS_LOG_TO_STDOUT=true
DATABASE_URL=<provided by Render PostgreSQL addon>
REDIS_URL=<provided by Render Key Value addon>
```
 
### Deploy
 
Auto-deploys on every push to `main`. To trigger manually:
 
```
Render Dashboard → your service → Manual Deploy → Deploy latest commit
```
 
### Health Check
 
```bash
curl https://task-manager-api-xoa6.onrender.com/health
```
 
```json
{
  "status": "healthy",
  "timestamp": "2026-03-20T12:00:00Z",
  "checks": {
    "database": true,
    "redis": true
  }
}
```
 
---
 
## API Documentation
 
Interactive Swagger UI is available at:
 
```
https://task-manager-api-xoa6.onrender.com/api-docs
```
 
To regenerate docs after changing swagger specs:
 
```bash
docker compose exec app bundle exec rake rswag:specs:swaggerize
```
 
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
│   ├── users/
│   │   ├── registrations_spec.rb
│   │   └── sessions_spec.rb
│   ├── swagger/
│   │   ├── auth_spec.rb
│   │   └── tasks_spec.rb
│   ├── authentication_spec.rb
│   ├── users_spec.rb
│   └── tasks_spec.rb
└── support/
    ├── jwt_helper.rb
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
- ✅ Authentication & Authorization
  - ✅ Devise setup and API configuration
  - ✅ JWT token generation and verification
  - ✅ Access token and refresh token flow
  - ✅ Role-based access control
  - ✅ Resource scoping — users can only access their own tasks
  - ✅ Test authentication flow with RSpec
- ✅ Advanced Features
  - ✅ Pagination
  - ✅ Filtering & Searching
  - ✅ Sorting
  - ✅ API Serializers
  - ✅ Error Handling
- ✅ Background Jobs
- ✅ Swagger Documentation
- ✅ Swagger Documentation
- ✅ Render Deployment
- ✅ Local setup Documentation
- ✅ Deployement Documentation


