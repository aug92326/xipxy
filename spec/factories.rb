FactoryGirl.define do
  factory :confirmed_user do
    sequence(:email) { |n| "admin_user#{n}@mailinator.com" }
    password 'password'
    password_confirmation 'password'
  end
end