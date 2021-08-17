class Result < ApplicationRecord
  belongs_to :user
  belongs_to :chart
  validates :random_option, presence: true
  validates :score, inclusion: { in: 0..100_000 }
  validates :gauge_amount, inclusion: { in: 0..24 }
  enum gauge_option: { normal: 0, easy: 1, hard: 2, danger: 3}
  enum random_option: { regular: 0, mirror: 1, random: 2, s_random: 3 }
  enum medal: { fail_circle: 0, fail_square: 1, fail_star: 2,
                clear_easy: 3, clear_circle: 4, clear_square: 5, clear_star: 6,
                fc_circle: 7, fc_square: 8, fc_star: 9, perfect: 10 }

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
end
