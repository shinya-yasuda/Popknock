class Admin::ChartsController < Admin::BaseController
  before_action :set_chart, only: %i[edit update]
  def edit; end

  def update
    if @chart.update(chart_params)
      redirect_to admin_musics_path, success: '譜面情報を更新しました'
    else
      flash.now[:danger] = '譜面更新に失敗しました'
      render :edit
    end
  end

  private

  def set_chart
    @chart = Chart.find(params[:id])
  end

  def chart_params
    params.require(:chart).permit(:level, :ran_level, :s_ran_level)
  end
end
