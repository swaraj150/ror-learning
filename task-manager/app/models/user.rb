class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password
  validates :name, :email, :password, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, length: { in: 8..20 }

  def as_json(options = {})
    super(options.merge(only: [ :id, :name, :email ]))
  end
end
