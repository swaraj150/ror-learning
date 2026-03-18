class TaskSerializer < BaseSerializer
  attributes :id,
             :title,
             :status,
             :priority,
             :due_date

  attribute :priority do
    object.priority  # enum label instead of integer
  end

  attribute :overdue do
    object.due_date.present? &&
      object.due_date < Time.current &&
      object.status != "completed"
  end

  attribute :due_date do
    formatted_date(object.due_date)
  end
end
