class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  has_many :tasks, dependent: :destroy
  validates :name, :email, :password, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, length: { in: 8..20 }, allow_nil: true

  def as_json(options = {})
    super(options.merge(only: [ :id, :name, :email ]))
  end
end
