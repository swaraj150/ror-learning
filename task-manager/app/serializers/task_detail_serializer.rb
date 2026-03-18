class TaskDetailSerializer < BaseSerializer
  attributes :id,
             :title,
             :description,
             :status,
             :priority,
             :due_date,
             :created_at,
             :updated_at

  attribute :priority do
    object.priority
  end

  attribute :overdue do
    object.due_date.present? &&
      object.due_date < Time.current &&
      object.status != "completed"
  end

  attribute :due_date do
    formatted_date(object.due_date)
  end

  attribute :created_at do
    datetime_iso(object.created_at)
  end

  attribute :updated_at do
    datetime_iso(object.updated_at)
  end

  belongs_to :user, serializer: UserSerializer
end
