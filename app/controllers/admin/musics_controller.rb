class Admin::MusicsController < Admin::BaseController
  before_action :set_music, only: %i[edit update destroy]
  def index
    @musics = Music.includes(:charts)
  end

  def new
    @music = Music.new
  end

  def create
    genre = music_params[:genre].present? ? music_params[:genre] : music_params[:name]
    @music = Music.new(name: music_params[:name], genre: genre)
    if @music.save
      params[:level].each_with_index do |lv, i|
        chart = Chart.new(music_id: @music.id, difficulty: i, level: lv)
        chart.save!
      end
      redirect_to admin_musics_path, success: '楽曲を追加しました'
    else
      flash.now[:danger] = '楽曲追加に失敗しました'
      render :new
    end
  end

  def edit; end

  def update
    genre = music_params[:genre].present? ? music_params[:genre] : music_params[:name]
    if @music.update(name: music_params[:name], genre: genre)
      @music.charts.each_with_index do |chart, i|
        chart.update(level: params[:level][i])
      end
      redirect_to admin_musics_path, success: '楽曲を更新しました'
    else
      flash.now[:danger] = '楽曲更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @music.destroy!
    redirect_to admin_musics_path
  end

  def csv_import
    Music.import(params[:file])
    redirect_to admin_musics_path
  end

  private

  def music_params
    params.require(:music).permit(:genre, :name, :level)
  end

  def set_music
    @music = Music.includes(:charts).find(params[:id])
  end
end
