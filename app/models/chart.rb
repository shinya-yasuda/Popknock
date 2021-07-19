class Chart < ApplicationRecord
  belongs_to :music
  has_many :results, dependent: :destroy
  validates :level, inclusion: { in: 1..50 }, allow_blank: true
  validates :ran_level, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :s_ran_level, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :difficulty, uniqueness: { scope: :music_id, message: 'この難易度の譜面はすでに存在します' }
  enum difficulty: { e: 0, N: 1, H: 2, EX: 3 }
end
