require 'image_process'
class ResultsController < ApplicationController
  include ImageProcess
  def new
    @result = Result.new
  end

  def create
    @result = Result.new
    unless check_image
      redirect_to new_result_path, danger: '適切なリザルト画像が投稿されていません'
      return
    end
    chart = Chart.find_by(music_id: music_id, difficulty: difficulty)
    @result = current_user.results.new(chart_id: chart.id, gauge_option: gauge_option, gauge_amount: gauge_amount,
                                       random_option: random_option, score: score, good: good, bad: bad)
    @result.medal = medal(@result.gauge_amount, @result.good, @result.bad, @result.gauge_option)
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

  def music_id
    image = load_image(result_params[:image])
    image.crop('242x58+272+66')
    target = pixels_array(image, 21, 5)
    data_array = array_distances(target, Music.where.not(pixels: nil).pluck(:pixels, :id))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def score
    score = ''
    materials = Material.where(style: 0, version: result_params[:version]).pluck(:pixels, :number)
    0.upto(5) do |i|
      cropped_image = load_image(result_params[:image]).crop("35x35+#{358 + i * 38}+176")
      target = pixels_array(cropped_image, 7, 7)
      data_array = array_distances(target, materials)
      score += data_array.min_by { |x| x[:distance] }[:id].to_s
    end
    score.to_i
  end

  def bad
    bad = ''
    materials = Material.where(style: 1, version: result_params[:version]).pluck(:pixels, :number)
    0.upto(2) do |i|
      cropped_image = load_image(result_params[:image]).crop("12x16+#{369 + i * 13}+265")
      target = pixels_array(cropped_image, 6, 8)
      data_array = array_distances(target, materials)
      bad += data_array.min_by { |x| x[:distance] }[:id].to_s
    end
    bad.to_i
  end

  def good
    good = ''
    materials = Material.where(style: 2, version: result_params[:version]).pluck(:pixels, :number)
    0.upto(2) do |i|
      cropped_image = load_image(result_params[:image]).crop("12x16+#{369 + i * 13}+248")
      target = pixels_array(cropped_image, 6, 8)
      data_array = array_distances(target, materials)
      good += data_array.min_by { |x| x[:distance] }[:id].to_s
    end
    good.to_i
  end

  def difficulty
    cropped_image = load_image(result_params[:image]).crop('57x12+285+51')
    target = pixels_array(cropped_image, 19, 4)
    data_array = array_distances(target, Material.where(style: 3).pluck(:pixels, :number))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def random_option
    cropped_image = load_image(result_params[:image]).crop('26x18+437+309')
    target = pixels_array(cropped_image, 13, 9)
    data_array = array_distances(target, Material.where(style: 5).pluck(:pixels, :number))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def gauge_option
    cropped_image = load_image(result_params[:image]).crop('26x18+396+309')
    target = pixels_array(cropped_image, 13, 9)
    data_array = array_distances(target, Material.where(style: 4).pluck(:pixels, :number))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def gauge_amount
    materials = Material.where(style: 6, version: result_params[:version]).pluck(:pixels, :number)
    24.downto(1) do |i|
      cropped_image = load_image(result_params[:image]).crop("5x5+#{263 + i * 13}+158")
      target = pixels_array(cropped_image, 5, 5)
      data_array = array_distances(target, materials)
      return i if data_array.min_by { |x| x[:distance] }[:id] == 1
    end
    0
  end

  def medal(gauge, good, bad, option)
    if bad == 0
      ('perfect' if good == 0) || ('fc_star' if good <= 5) || ('fc_square' if good <= 20) || 'fc_circle'
    elsif gauge >= 17
      ('clear_easy' if option == 'easy') || ('clear_star' if bad <= 5) || ('clear_square' if bad <= 20) || 'clear_circle'
    elsif option != 'easy'
      ('fail_star' if gauge >= 15)|| ('fail_square' if gauge >= 12) || 'fail_circle'
    else
    'fail_circle'
    end
  end
end
