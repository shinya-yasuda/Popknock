class Chart < ApplicationRecord
  belongs_to :music
  has_many :results, dependent: :destroy
  validates :level, inclusion: { in: 1..50 }
  validates :ran_level, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :s_ran_level, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :difficulty, uniqueness: { scope: :music_id, message: 'この難易度の譜面はすでに存在します' }
  enum difficulty: { easy: 0, N: 1, H: 2, EX: 3 }
  scope :sort_by_best_medal_asc, -> { eager_load(:results).where(results: { medal: Result.group(:chart_id).select('max(medal)'), user_id: User.current_user.id }).order('results.medal': :asc) }
  scope :sort_by_best_medal_desc, -> { eager_load(:results).where(results: { medal: Result.group(:chart_id).select('max(medal)'), user_id: User.current_user.id }).order('results.medal': :desc) }
  scope :sort_by_best_score_asc, -> { eager_load(:results).where(results: { score: Result.group(:chart_id).select('max(score)'), user_id: User.current_user.id }).order('results.score': :asc) }
  scope :sort_by_best_score_desc, -> { eager_load(:results).where(results: { score: Result.group(:chart_id).select('max(score)'), user_id: User.current_user.id }).order('results.score': :desc) }
  scope :sort_by_least_bad_asc, -> { eager_load(:results).where(results: { bad: Result.group(:chart_id).select('min(bad)'), user_id: User.current_user.id }).order('results.bad': :asc) }
  scope :sort_by_least_bad_desc, -> { eager_load(:results).where(results: { bad: Result.group(:chart_id).select('min(bad)'), user_id: User.current_user.id }).order('results.bad': :desc) }

  class << self
    include ImageProcess
    def search_by_image(file)
      music_id = music_id(file)
      difficulty = difficulty(file)
      Chart.find_by(music_id: music_id, difficulty: difficulty)
    end

    def music_id(file)
      cropped_image = load_image(file).crop('242x58+272+66')
      target = pixels_array(cropped_image, 21, 5)
      data_array = array_distances(target, Music.where.not(pixels: nil).pluck(:pixels, :id))
      data_array.min_by { |x| x[:distance] }[:id] if data_array.min_by { |x| x[:distance] }[:distance] < 20
    end

    def difficulty(file)
      cropped_image = load_image(file).crop('57x12+285+51')
      target = pixels_array(cropped_image, 19, 4)
      data_array = array_distances(target, Material.where(style: :difficulty).pluck(:pixels, :number))
      data_array.min_by { |x| x[:distance] }[:id]
    end
  end
end
