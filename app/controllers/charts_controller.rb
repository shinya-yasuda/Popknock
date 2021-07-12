class ChartsController < ApplicationController
  def levels; end

  def index
    @level = params[:level]
    @charts = Chart.where(level: @level)
  end
end
