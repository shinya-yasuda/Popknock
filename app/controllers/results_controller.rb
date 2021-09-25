require 'image_process'
class ResultsController < ApplicationController
  include ImageProcess
  def new
    @result = Result.new
  end

  def create
    unless check_image
      redirect_to new_result_path, danger: 'プレーシェア画像を投稿してください'
      return
    end
    @result = Result.new
    chart = Chart.search_by_image(result_params[:image])
    if chart && @result.get_version(result_params[:image])
      @result = current_user.results.new(chart_id: chart.id)
      @result.analyze_image(result_params[:image])
      if @result.save
        redirect_to new_result_path, success: "LV#{@result.chart.level} #{@result.chart.music.name}(#{chart.difficulty})のリザルトを投稿しました"
      else
        flash.now[:danger] = 'リザルトの読み取り中にエラーが発生しました'
        render :new
      end
    else
      flash.now[:danger] = 'この画像には対応していません'
      render :new
    end
  end

  def destroy
    result = Result.find(params[:id])
    chart = result.chart
    result.destroy!
    redirect_to chart_path(chart), success: 'リザルトを削除しました'
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
