FactoryGirl.define do
  factory :user do |f|
    f.email { Faker::Internet.email }
    f.password Faker::Internet.password
    f.role User::ADMIN
  end

  trait :admin do |f|
    f.role User::ADMIN.to_s
  end

  trait :normal do |f|
    f.role User::NORMAL.to_s
  end

  before(:create, &:generate_authentication_token!)
end
