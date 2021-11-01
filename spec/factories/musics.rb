FactoryBot.define do
  sequence :etude_title do |i|
    "etude#{i}"
  end
  factory :music do
    name { 'test_music' }
    genre { 'test' }
  end
  factory :etude, class: Music do
    name { generate :etude_title }
    genre { 'etude' }
  end
end
