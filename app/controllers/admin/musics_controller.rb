class Admin::MusicsController < Admin::BaseController
  def index
    @musics = Music.includes(:charts)
  end

  def new
    @music = Music.new
  end

  def create
    @music = Music.new(name: params[:music][:name])
    @music.save!
    params[:level].each_with_index do |lv, i|
      chart = Chart.new(music_id: @music.id, difficulty: i, level: lv.to_i)
      chart.save!
    end
    redirect_to levels_path
  end

  private

  def music_params
    params.require(:music).permit(:name, :level_easy, :level_N, :level_H, :level_EX)
  end
end
