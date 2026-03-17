FactoryBot.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.unique.email }
    password { "password123" }
    role     { :user }
  end

  trait :admin do
    role { :admin }
  end
end
