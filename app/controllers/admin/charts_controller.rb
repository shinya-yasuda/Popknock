class Admin::ChartsController < Admin::BaseController
  before_action :set_chart, only: %i[edit update destroy]
  def new
    @music = Music.find(params[:music_id])
    @chart = Chart.new
  end

  def create
    @music = Music.find(params[:music_id])
    @chart = @music.charts.new(chart_params)
    if @chart.save
      redirect_to edit_admin_music_path(@music), success: '譜面を追加しました'
    else
      flash.now[:danger] = '譜面を追加出来ませんでした'
      render :new
    end
  end

  def edit; end

  def update
    if @chart.update(chart_params)
      redirect_to edit_admin_music_path(@chart.music), success: '譜面情報を更新しました'
    else
      flash.now[:danger] = '譜面更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @music = Music.find(params[:music_id])
    @chart.destroy!
    redirect_to edit_admin_music_path(@music), success: '譜面を削除しました'
  end

  private

  def set_chart
    @chart = Chart.find(params[:id])
  end

  def chart_params
    params.require(:chart).permit(:difficulty, :level, :ran_level, :s_ran_level)
  end
end
