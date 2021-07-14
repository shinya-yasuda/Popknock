class Chart < ApplicationRecord
  belongs_to :music
  validates :level, inclusion: { in: 1..50 }, allow_blank: true
  validates :ran_level, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :s_ran_level, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :difficulty, uniqueness: { scope: :music_id, message: 'この難易度の譜面はすでに存在します' }
  enum difficulty: { easy: 0, normal: 1, hyper: 2, extra: 3 }
end
