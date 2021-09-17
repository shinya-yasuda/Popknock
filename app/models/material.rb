class Material < ApplicationRecord
  validates :number, presence: true
  validates :style, presence: true
  validates :version, presence: true
  enum style: { score: 0, bad: 1, good: 2, difficulty: 3, gauge_option: 4, random_option: 5,
                gauge: 6, gauge_option_simple: 7, option_type: 8 }
  enum version: { usaneko: 24, peace: 25, riddles: 26 }
end
