class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  has_many :tasks, dependent: :destroy
  enum :role, { user: 0, admin: 1 }
  after_initialize :set_default_role, if: :new_record?
  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, length: { in: 8..20 }, allow_nil: true

  def as_json(options = {})
    super(options.merge(only: [ :id, :name, :email ]))
  end
  private
  def set_default_role
    self.role ||= :user
  end
end
