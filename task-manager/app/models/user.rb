class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password_digest, length: { in: 8..20 }
end
