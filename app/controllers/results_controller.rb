require 'image_process'
class ResultsController < ApplicationController
  include ImageProcess
  def new
    @result = Result.new
  end

  def create
    @result = Result.new
    if result_params[:images]
      successes = []
      duplicates = []
      disorders = []
      i = 0
      result_params[:images].each do |img|
        i += 1
        unless check_image(img)
          disorders << i
          next
        end
        chart = Chart.search_by_image(img)
        if chart && @result.get_version(img)
          @result = current_user.results.new(chart_id: chart.id)
          @result.analyze_image(img)
          if @result.save
            successes << i
          elsif @result.errors.details[:played_at]
            duplicates << i
          else
            disorders << i
          end
        else
          disorders << i
        end
      end
      message = duplicates.present? ? "#{duplicates.join(',')}枚目のリザルトは投稿済です " : ''
      message += "#{disorders.join(',')}枚目の画像読み取りに失敗しました" if disorders.present?
      flash[:success] = "#{successes.count}枚のリザルトを保存しました" if successes.present?
      flash[:danger] = message if message.present?
      redirect_to new_result_path
    else
      flash.now[:danger] = 'プレーシェア画像を選択してください'
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
    params.require(:result).permit(:version, images: [])
  end

  def check_image(image)
    img = load_image(image)
    img.width == 600 && img.height == 400
  end
end
