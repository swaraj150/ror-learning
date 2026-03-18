class Task < ApplicationRecord
  belongs_to :user
  enum :status, {
    todo: "todo",
    in_progress: "in_progress",
    completed: "completed"
  }
  enum :priority, {
    low: 0,
    medium: 1,
    high: 2
  }
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :priority,  inclusion: { in: priorities.keys.map(&:to_s) }

  scope :by_priority, ->(dir = :desc) { order(priority: dir) }
  scope :by_due_date, ->(dir = :asc) { order(due_date: dir) }
  scope :by_created_at, ->(dir = :desc) { order(due_date: dir) }
end
