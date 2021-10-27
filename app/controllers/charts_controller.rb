class ChartsController < ApplicationController
  helper_method :sort_direction
  def levels
    @option = params[:option]
    @results = if @option.present?
                 current_user.results.where(random_option: @option).decorate
               else
                 current_user.results.decorate
               end
  end

  def ran_levels; end

  def s_ran_levels; end

  def index
    @level = params[:level]
    @option = params[:option]
    @results = if @option.present?
                 current_user.results.eager_load(:chart).where(charts: { level: @level }, random_option: @option)
               else
                 current_user.results.eager_load(:chart).where(charts: { level: @level })
               end
    if params[:sort].present?
      case params[:column]
      when 'medal'
        @charts = Chart.sort_charts_medal(@results, params[:sort], @level)
      when 'score'
        @charts = Chart.sort_charts_score(@results, params[:sort], @level)
      when 'bad'
        @charts = Chart.sort_charts_bad(@results, params[:sort], @level)
      else
        @charts = Chart.where(level: @level).joins(:music).order(genre: :asc)
      end
    else
      @charts = Chart.where(level: @level).joins(:music).order(genre: :asc)
    end
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
    @score_graphs = @results.decorate.score_graphs
    @bad_graphs = @results.decorate.bad_graphs
    # スコアグラフの上端と下端を10000の倍数にする
    @max_score = @results.maximum(:score)&.ceil(-4)
    @min_score = @results.minimum(:score)&.floor(-4)
  end

  def detail
    @chart = Chart.find(params[:id])
    @results = @chart.results.where(user_id: current_user.id).order(played_at: :desc)
  end

  private

  def sort_direction
    %w[asc desc].include?(params[:sort]) ? params[:sort] : 'asc'
  end

end
