class ChartsController < ApplicationController
  def levels; end

  def ran_levels; end

  def s_ran_levels; end

  def index
    @level = params[:level]
    @charts = Chart.where(level: @level)
  end

  def show
    @chart = Chart.find(params[:id])
  end
end
