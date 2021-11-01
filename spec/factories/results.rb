FactoryBot.define do
  factory :result do
    gauge_option { 'normal' }
    random_option { 'regular' }
    score { 99_000 }
    gauge_amount { 24 }
    good { 0 }
    bad { 0 }
    played_at { Time.now }
    trait :easy_gauge do
      gauge_option { 'easy' }
    end
    trait :hard_gauge do
      gauge_option { 'hard' }
    end
    trait :danger_gauge do
      gauge_option { 'danger' }
    end
  end
end
