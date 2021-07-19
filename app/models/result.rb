class Result < ApplicationRecord
  belongs_to :user
  belongs_to :chart
  validates :option, presence: true
  validates :score, inclusion: { in: 0..100_000 }
  enum option: { regular: 0, mirror: 1, random: 2, s_random: 3 }
  enum medal: { fail_circle: 0, fail_square: 1, fail_star: 2,
                clear_easy: 3, clear_circle: 4, clear_square: 5, clear_star: 6,
                fc_circle: 7, fc_square: 8, fc_star: 9, perfect: 10 }
end
