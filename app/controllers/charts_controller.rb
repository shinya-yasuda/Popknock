class ChartsController < ApplicationController
  before_action :set_q, only: %i[index ran_index s_ran_index]
  before_action :set_r, only: %i[index ran_index s_ran_index show]
  def levels
    @results = current_user.results.decorate
  end

  def ran_levels; end

  def s_ran_levels; end

  def index
    @charts = @q.result
    @results = @r.result
  end

  def ran_index
    @level = params[:level] || params[:r][:level]
    @charts = Chart.where(ran_level: @level).joins(:music).merge(Music.where.not(pixels: nil))
    @results = current_user.results.where(random_option: :random)
  end

  def s_ran_index
    @level = params[:level] || params[:r][:level]
    @charts = Chart.where(s_ran_level: @level).joins(:music).merge(Music.where.not(pixels: nil))
    @results = current_user.results.where(random_option: :s-random)
  end

  def show
    @chart = Chart.find(params[:id])
    @results = @chart.results.where(user_id: current_user.id).order(played_at: :asc)
    @score_graphs = []
    @bad_graphs = []
    Result.random_options.each do |option|
      @score_graphs << { name: t(option[0]), data: @results.where(random_option: option).pluck(:played_at, :score).map { |record| [I18n.l(record[0]), record[1]] } }
      @bad_graphs << { name: t(option[0]), data: @results.where(random_option: option).pluck(:played_at, :bad).map { |record| [I18n.l(record[0]), record[1]] } }
    end
    #スコアグラフの上端と下端を10000の倍数にする
    @max_score = @results.maximum(:score)&.ceil(-4)
    @min_score = @results.minimum(:score)&.floor(-4)
  end

  def detail
    @chart = Chart.find(params[:id])
    @results = @chart.results.where(user_id: current_user.id).order(played_at: :desc)
  end

  private

  def set_q
    @level = params[:level] || params[:r][:level]
    @q = Chart.where(level: @level).eager_load(:music, :results).order(genre: :asc).ransack(params[:q])
  end

  def set_r
    @r = current_user.results.ransack(params[:r], search_key: :r)
  end
end
