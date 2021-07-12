class Chart < ApplicationRecord
  belongs_to :music
  validates :level, presence: true, numericality: { in: 1..50 }
  enum difficulty: { easy: 0, normal: 1, hyper: 2, extra: 3 }
end
