require 'image_process'
class ResultsController < ApplicationController
  include ImageProcess
  def new
    @result = Result.new
  end

  def create
    unless check_image
      redirect_to new_result_path, danger: '適切なリザルト画像が投稿されていません'
      return
    end
    chart = Chart.search_by_image(result_params[:image])
    @result = current_user.results.new(chart_id: chart.id)
    @result.analyze_image(result_params[:image], result_params[:version])
    @result.get_medal
    if @result.save
      redirect_to new_result_path, success: "#{@result.chart.music.name}のリザルトを投稿しました"
    else
      flash.now[:danger] = 'リザルト画像を正常に分析出来ませんでした'
      render :new
    end
  end

  private

  def result_params
    params.require(:result).permit(:image, :version)
  end

  def check_image
    return false unless result_params[:image]

    image = load_image(result_params[:image])
    image.width == 600 && image.height == 400
  end
end
