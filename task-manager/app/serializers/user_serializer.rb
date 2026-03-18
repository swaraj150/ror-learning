class UserSerializer < BaseSerializer
  attributes :id, :name, :email, :role, :created_at

  attribute :task_count do
    object.tasks.count
  end
end
