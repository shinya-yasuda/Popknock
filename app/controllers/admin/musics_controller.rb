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
        Chart.create(music_id: @music.id, difficulty: i, level: lv)
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
      redirect_to admin_musics_path, success: '楽曲を更新しました'
    else
      flash.now[:danger] = '楽曲更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @music.destroy!
    redirect_to admin_musics_path, success: '楽曲を削除しました'
  end

  def csv_import
    Music.import(params[:file])
    redirect_to admin_musics_path, success: 'CSVファイルの読み込みが完了しました'
  end

  private

  def music_params
    params.require(:music).permit(:genre, :name, :level)
  end

  def set_music
    @music = Music.includes(:charts).find(params[:id])
  end
end
