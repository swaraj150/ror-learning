class Task < ApplicationRecord
  belongs_to :user
  validates :title, :status, presence: true
  validates :priority,  numericality: { greater_than: 0, less_than_or_equal_to: 5 }
end
