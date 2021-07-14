class Chart < ApplicationRecord
  belongs_to :music
  validates :level, uniqueness: { scope: :music_id, message: 'この難易度の譜面はすでに存在します' }, inclusion: { in: 1..50 }, allow_blank: true
  enum difficulty: { easy: 0, normal: 1, hyper: 2, extra: 3 }
end
