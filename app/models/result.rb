class Result < ApplicationRecord
  include ImageProcess
  belongs_to :user
  belongs_to :chart
  validates :random_option, presence: true
  validates :score, inclusion: { in: 0..100_000 }
  validates :gauge_amount, inclusion: { in: 0..24 }
  enum gauge_option: { normal: 0, easy: 1, hard: 2, danger: 3 }
  enum random_option: { regular: 0, mirror: 1, random: 2, s_random: 3 }
  enum medal: { fail_circle: 0, fail_square: 1, fail_star: 2,
                clear_easy: 3, clear_circle: 4, clear_square: 5, clear_star: 6,
                hard_circle: 7, hard_square: 8, hard_star: 9,
                fc_circle: 10, fc_square: 11, fc_star: 12, perfect: 13 }

  class << self
    def best_medal(chart)
      where(chart_id: chart.id).maximum(:medal)
    end

    def hi_score(chart)
      where(chart_id: chart.id).maximum(:score)
    end

    def least_bad(chart)
      where(chart_id: chart.id).minimum(:bad)
    end

    def medal_by_option(option)
      where(random_option: option).maximum(:medal)
    end

    def hi_score_by_option(option)
      where(random_option: option).maximum(:score)
    end

    def least_bad_by_option(option)
      where(random_option: option).minimum(:bad)
    end

    def average_score(option, count)
      where(random_option: option).order(created_at: :desc).limit(count).average(:score)
    end
  end

  def load_image(file)
    image = MiniMagick::Image.open(file)
    MiniMagick::Image.read(image)
  end

  def analyze_image(file, version)
    self.score = get_score(file, version)
    self.bad = get_bad(file, version)
    self.good = get_good(file, version)
    self.random_option = get_random_option(file, version)
    self.gauge_option = get_gauge_option(file, version)
    self.gauge_amount = get_gauge_amount(file, version)
  end

  def get_score(file, version)
    score = ''
    materials = Material.where(style: :score, version: version).pluck(:pixels, :number)
    0.upto(5) do |i|
      cropped_image = load_image(file).crop("35x35+#{358 + i * 38}+176")
      target = pixels_array(cropped_image, 7, 7)
      data_array = array_distances(target, materials)
      score += data_array.min_by { |x| x[:distance] }[:id].to_s
    end
    score.to_i
  end

  def get_bad(file, version)
    bad = ''
    materials = Material.where(style: :bad, version: version).pluck(:pixels, :number)
    0.upto(2) do |i|
      cropped_image = load_image(file).crop("12x16+#{369 + i * 13}+265")
      target = pixels_array(cropped_image, 6, 8)
      data_array = array_distances(target, materials)
      bad += data_array.min_by { |x| x[:distance] }[:id].to_s
    end
    bad.to_i
  end

  def get_good(file, version)
    good = ''
    materials = Material.where(style: :good, version: version).pluck(:pixels, :number)
    0.upto(2) do |i|
      cropped_image = load_image(file).crop("12x16+#{369 + i * 13}+248")
      target = pixels_array(cropped_image, 6, 8)
      data_array = array_distances(target, materials)
      good += data_array.min_by { |x| x[:distance] }[:id].to_s
    end
    good.to_i
  end

  def get_random_option(file, version)
    cropped_image = load_image(file).crop('26x18+437+309')
    target = pixels_array(cropped_image, 13, 9)
    data_array = array_distances(target, Material.where(style: :random_option, version: version).pluck(:pixels, :number))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def get_gauge_option(file, version)
    cropped_image = load_image(file).crop('26x18+396+309')
    target = pixels_array(cropped_image, 13, 9)
    data_array = array_distances(target, Material.where(style: :gauge_option, version: version).pluck(:pixels, :number))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def get_gauge_amount(file, version)
    materials = Material.where(style: :gauge, version: version).pluck(:pixels, :number)
    24.downto(1) do |i|
      cropped_image = load_image(file).crop("5x5+#{263 + i * 13}+158")
      target = pixels_array(cropped_image, 5, 5)
      data_array = array_distances(target, materials)
      return i if data_array.min_by { |x| x[:distance] }[:id] == 1
    end
    0
  end

  def get_medal
    self.medal = if bad == 0
                   ('perfect' if good == 0) || ('fc_star' if good <= 5) || ('fc_square' if good <= 20) || 'fc_circle'
                 elsif gauge_amount >= 17
                   ('clear_easy' if gauge_option == 'easy') || ('clear_star' if bad <= 5) || ('clear_square' if bad <= 20) || 'clear_circle'
                 elsif gauge_option != 'easy'
                   ('fail_star' if gauge_amount >= 15)|| ('fail_square' if gauge_amount >= 12) || 'fail_circle'
                 else
                   'fail_circle'
                 end
  end
end
