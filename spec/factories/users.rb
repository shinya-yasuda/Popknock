FactoryBot.define do
  factory :tester, class: User do
    name { 'tester' }
    email { 'tester@example.com' }
    password { 'testpass' }
    password_confirmation { 'testpass' }
  end
end
