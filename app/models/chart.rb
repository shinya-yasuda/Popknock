class Chart < ApplicationRecord
  belongs_to :music
  has_many :results, dependent: :destroy
  validates :level, inclusion: { in: 1..50 }
  validates :ran_level, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :s_ran_level, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :difficulty, uniqueness: { scope: :music_id, message: 'この難易度の譜面はすでに存在します' }
  enum difficulty: { easy: 0, N: 1, H: 2, EX: 3 }
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

    def sort_charts_medal(results, direction, level)
      hash = results.group(:chart_id).maximum(:medal)
      get_sorted_charts(hash, direction, level)
    end

    def sort_charts_score(results, direction, level)
      hash = results.group(:chart_id).maximum(:score)
      get_sorted_charts(hash, direction, level)
    end

    def sort_charts_bad(results, direction, level)
      hash = results.group(:chart_id).minimum(:bad)
      get_sorted_charts(hash, direction, level)
    end

    def get_sorted_charts(hash, direction, level)
      array = direction == 'desc' ? hash.sort_by { |_, v| v } : hash.sort_by { |_, v| v }.reverse
      charts = []
      level_charts = Chart.where(level: level).to_a
      array.each do |a|
        chart =  Chart.find(a[0])
        charts << chart
        level_charts.delete(chart)
      end
      charts + level_charts
    end
  end
end
