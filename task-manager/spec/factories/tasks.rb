FactoryBot.define do
  factory :task do
    sequence(:title)       { |n| "Task #{n}" }
    description            { 'Sample task description' }
    status                 { 'pending' }
    priority               { 1 }
    due_date               { 1.week.from_now }
    association :user      
  end

  trait :completed do
    status { 'completed' }
  end

  trait :high_priority do
    priority { 3 }
  end

  trait :overdue do
    due_date { 1.week.ago }
  end
end