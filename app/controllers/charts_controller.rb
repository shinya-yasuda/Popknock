class ChartsController < ApplicationController
  def levels; end

  def ran_levels; end

  def s_ran_levels; end

  def index
    @level = params[:level]
    @charts = Chart.where(level: @level)
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
