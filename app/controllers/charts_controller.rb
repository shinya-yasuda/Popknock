class ChartsController < ApplicationController
  before_action :set_q, only: %i[index ran_index s_ran_index show]
  def levels; end

  def ran_levels; end

  def s_ran_levels; end

  def index
    @level = params[:level] || params[:q][:level]
    @charts = Chart.where(level: @level).joins(:music).merge(Music.where.not(pixels: nil))
    @results = @q.result(distinct: true)
  end

  def ran_index
    @level = params[:level] || params[:q][:level]
    @charts = Chart.where(ran_level: @level).joins(:music).merge(Music.where.not(pixels: nil))
    @results = current_user.results.where(random_option: 2)
  end

  def s_ran_index
    @level = params[:level] || params[:q][:level]
    @charts = Chart.where(s_ran_level: @level).joins(:music).merge(Music.where.not(pixels: nil))
    @results = current_user.results.where(random_option: 3)
  end

  def show
    @chart = Chart.find(params[:id])
    @results = @chart.results.where(user_id: current_user.id)
    @bad_graph = @results.order(created_at: :asc).pluck(:created_at, :bad)
    @score_graph = @results.order(created_at: :asc).pluck(:created_at, :score)
  end

  private

  def set_q
    @q = current_user.results.ransack(params[:q])
  end
end
