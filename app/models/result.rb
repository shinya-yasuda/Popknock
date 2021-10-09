class Result < ApplicationRecord
  include ImageProcess
  belongs_to :user
  belongs_to :chart
  validates :random_option, presence: true
  validates :score, inclusion: { in: 0..100_000 }
  validates :gauge_amount, inclusion: { in: 0..24 }
  validates :played_at, uniqueness: { scope: [:user_id, :chart_id], message: 'と楽曲が同じリザルトが既にあります' }
  enum gauge_option: { normal: 0, easy: 1, hard: 2, danger: 3 }
  enum random_option: { regular: 0, mirror: 1, random: 2, s_random: 3 }
  enum medal: { fail_circle: 0, fail_square: 1, fail_star: 2,
                clear_easy: 3, clear_circle: 4, clear_square: 5, clear_star: 6,
                hard_circle: 7, hard_square: 8, hard_star: 9,
                danger_circle: 10, danger_square: 11, danger_star: 12,
                fc_circle: 13, fc_square: 14, fc_star: 15, perfect: 16 }

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

    def pickup_level(level)
      eager_load(:chart).where("charts.level = ?", level)
    end
  end

  def analyze_image(file)
    version = get_version(file)
    self.score = get_score(file, version)
    self.bad = get_bad(file, version)
    self.good = get_good(file, version)
    self.gauge_amount = get_gauge_amount(file, version)
    self.played_at = get_played_at(file, version)
    if simple_check(file, version)
      self.gauge_option = get_gauge_option_simple(file, version)
      self.random_option = :regular
    else
      self.gauge_option = get_gauge_option(file, version)
      self.random_option = get_random_option(file, version)
    end
    self.get_medal
  end

  def simple_check(file, version)
    materials = Material.where(style: :option_type, version: version).pluck(:pixels, :number)
    get_number(file, materials, 30, 15, 10, 5, 293, 330) == 0
  end

  def get_version(file)
    materials = Material.where(style: :version).pluck(:pixels, :version)
    get_number(file, materials, 60, 15, 20, 5, 296, 185)
  end
  
  def get_number(file, array, x, y, resize_x, resize_y, margin_x, margin_y)
    cropped_image = load_image(file).crop("#{x}x#{y}+#{margin_x}+#{margin_y}")
    target = pixels_array(cropped_image, resize_x, resize_y)
    data_array = array_distances(target, array)
    data_array.min_by { |n| n[:distance] }[:id] if data_array.min_by { |n| n[:distance] }[:distance] < 20
  end

  def get_score(file, version)
    score = ''
    materials = Material.where(style: :score, version: version).pluck(:pixels, :number)
    0.upto(5) do |i|
      score += get_number(file, materials, 35, 35, 7, 7, 358+i*38, 176).to_s
    end
    score.to_i
  end

  def get_bad(file, version)
    bad = ''
    materials = Material.where(style: :bad, version: version).pluck(:pixels, :number)
    0.upto(3) do |i|
      bad += get_number(file, materials, 12, 16, 6, 8, 356+i*13, 265).to_s
    end
    bad.to_i
  end

  def get_good(file, version)
    good = ''
    materials = Material.where(style: :good, version: version).pluck(:pixels, :number)
    0.upto(3) do |i|
      good += get_number(file, materials, 12, 16, 6, 8, 356+i*13, 248).to_s
    end
    good.to_i
  end

  def get_random_option(file, version)
    materials = Material.where(style: :random_option, version: version).pluck(:pixels, :number)
    get_number(file, materials, 26, 18, 13, 9, 437, 309)
  end

  def get_gauge_option(file, version)
    materials = Material.where(style: :gauge_option, version: version).pluck(:pixels, :number)
    get_number(file, materials, 26, 18, 13, 9, 396, 309)
  end

  def get_gauge_option_simple(file, version)
    materials = Material.where(style: :gauge_option_simple, version: version).pluck(:pixels, :number)
    get_number(file, materials, 25, 25, 5, 5, 533, 344)
  end

  def get_gauge_amount(file, version)
    materials = Material.where(style: :gauge, version: version).pluck(:pixels, :number)
    24.downto(1) do |i|
      return i if get_number(file, materials, 5, 5, 5, 5, 263+i*13, 158) == 1
    end
    0
  end

  def get_played_at(file, version)
    materials = Material.where(style: :date, version: version).pluck(:pixels, :number)
    starts = [15, 22, 29, 36, 50, 57, 71, 78, 92, 99, 112, 119, 132, 139]
    time = ''
    0.upto(13) do |i|
      time += get_number(file, materials, 6, 11, 6, 11, starts[i], 18).to_s
    end
    Time.strptime(time, '%Y%m%d%H%M%S')
  end

  def get_medal
    self.medal = if bad == 0
                   (:perfect if good == 0) || (:fc_star if good <= 5) || (:fc_square if good <= 20) || :fc_circle
                 elsif gauge_amount >= 17
                   if gauge_option == 'danger'
                     (:danger_star if bad <= 5) || (:danger_square if bad <= 20) || :danger_circle
                   elsif gauge_option == 'hard'
                     (:hard_star if bad <= 5) || (:hard_square if bad <= 20) || :hard_circle
                   else
                     (:clear_easy if gauge_option == 'easy') || (:clear_star if bad <= 5) || (:clear_square if bad <= 20) || :clear_circle
                   end
                 elsif gauge_option != 'easy'
                   (:fail_star if gauge_amount >= 15)|| (:fail_square if gauge_amount >= 12) || :fail_circle
                 else
                   :fail_circle
                 end
  end
end
