FactoryBot.define do
  factory :user do
    name { 'John' }
    email { 'john@example.com' }
    password_digest { 'foobarbazz' }
  end
end