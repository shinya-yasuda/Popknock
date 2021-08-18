class ChartsController < ApplicationController
  before_action :search_result, only: %i[index show]
  def levels; end

  def ran_levels; end

  def s_ran_levels; end

  def index
    if params[:level]
      @level = params[:level]
      @charts = Chart.where(level: @level)
    elsif params[:ran_level]
      @level = params[:ran_level]
      @charts = Chart.where(ran_level: @level)
    elsif params[:s_ran_level]
      @level = params[:s_ran_level]
      @charts = Chart.where(s_ran_level: @level)
    end
    @results = current_user.results
  end

  def show
    @chart = Chart.find(params[:id])
    @results = @chart.results.where(user_id: current_user.id)
    @bad_graph = @chart.results.where(user_id: current_user.id).order(created_at: :asc).pluck(:created_at, :bad)
    @score_graph = @chart.results.where(user_id: current_user.id).order(created_at: :asc).pluck(:created_at, :score)
  end

  private

  def search_result
    @q = current_user.results.ransack(params[:q])
  end
end
