require 'image_process'
class Admin::MusicsController < Admin::BaseController
  include ImageProcess
  before_action :set_music, only: %i[edit update destroy]
  before_action :set_q, only: :index
  before_action :set_r, only: :remain
  def index
    @musics = @q.result(distinct: true).includes(:charts).order(genre: :asc).page(params[:page])
  end

  def remain
    @musics = @r.result(distinct: true).includes(:charts).order(genre: :asc).page(params[:page])
  end

  def new
    @music = Music.new
  end

  def create
    @music = Music.new(name: music_params[:name], genre: music_genre, pixels: banner_pixels)
    if @music.save
      params[:level].each_with_index do |lv, i|
        Chart.create(music_id: @music.id, difficulty: i, level: lv)
      end
      redirect_to admin_musics_path, success: "楽曲#{@music.name}を追加しました"
    else
      flash.now[:danger] = '楽曲追加に失敗しました'
      render :new
    end
  end

  def edit
    @charts = @music.charts.order(difficulty: :asc)
  end

  def update
    if @music.update(name: music_params[:name], genre: music_genre, pixels: banner_pixels)
      redirect_to remain_admin_musics_path, success: "#{@music.name}の情報を更新しました"
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
    Music.import_create(params[:file])
    redirect_to admin_musics_path, success: 'CSVファイルの読み込みが完了しました'
  end

  def csv_edit
    Music.import_edit(params[:file])
    redirect_to admin_musics_path, success: 'CSVファイルの読み込みが完了しました'
  end

  private

  def music_params
    params.require(:music).permit(:genre, :name, :banner)
  end

  def chart_params
    params.require(:music).permit(:level)
  end

  def set_music
    @music = Music.includes(:charts).find(params[:id])
  end

  def music_genre
    music_params[:genre].present? ? music_params[:genre] : music_params[:name]
  end

  def banner_pixels
    return nil unless music_params[:banner]

    image = load_image(music_params[:banner])
    return nil if image[:height] != 58 && image[:height] != 400

    image.crop('242x58+272+66') if image[:width] == 600 && image[:height] == 400
    pixels_array(image, 21, 5)
  end

  def set_q
    @q = Music.all.ransack(params[:q])
  end

  def set_r
    @r = Music.where(pixels: nil).ransack(params[:q])
  end
end
