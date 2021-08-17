require 'image_process'
class ResultsController < ApplicationController
  include ImageProcess
  def new
    @result = Result.new
  end

  def create
    chart = Chart.find_by(music_id: music_id, difficulty: difficulty)
    @result = current_user.results.new(chart_id: chart.id, gauge_option: 0, gauge_amount: gauge_amount,
                                       random_option: random_option, score: score, good: good, bad: bad)
    @result.medal = medal(@result.gauge_amount, @result.good, @result.bad, @result.gauge_option)
    if @result.save
      redirect_to new_result_path, success: 'リザルトを投稿しました'
    else
      flash.now[:danger] = 'リザルトを投稿出来ませんでした'
    end
  end

  private

  def result_params
    params.require(:result).permit(:result)
  end

  def diff_abs(array1, array2)
    (array1 - array2).abs
  end

  def distance(array1, array2)
    diff_abs(array1, array2).sum
  end

  def data_params(target, array, index)
    { id: index, distance: distance(target, array) }
  end

  def array_distances(target, list)
    ary = []
    list.each do |item, index|
      temp_data_params = data_params(Numo::Int16.cast(target), Numo::Int16.cast(item), index)
      ary << temp_data_params
    end
    ary
  end

  def music_id
    image = load_image(result_params[:result])
    image.crop('242x58+272+66')
    target = pixels_array(image, 21, 5)
    data_array = array_distances(target, Music.pluck(:pixels, :id))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def score
    score = ''
    materials = Material.where(style: 0).pluck(:pixels, :number)
    0.upto(5) do |i|
      cropped_image = load_image(result_params[:result]).crop("35x35+#{358 + i * 38}+176")
      target = pixels_array(cropped_image, 7, 7)
      data_array = array_distances(target, materials)
      score += data_array.min_by { |x| x[:distance] }[:id].to_s
    end
    score.to_i
  end

  def bad
    bad = ''
    materials = Material.where(style: 1).pluck(:pixels, :number)
    0.upto(2) do |i|
      cropped_image = load_image(result_params[:result]).crop("12x16+#{369 + i * 13}+265")
      target = pixels_array(cropped_image, 6, 8)
      data_array = array_distances(target, materials)
      bad += data_array.min_by { |x| x[:distance] }[:id].to_s
    end
    bad.to_i
  end

  def good
    good = ''
    materials = Material.where(style: 2).pluck(:pixels, :number)
    0.upto(2) do |i|
      cropped_image = load_image(result_params[:result]).crop("12x16+#{369 + i * 13}+248")
      target = pixels_array(cropped_image, 6, 8)
      data_array = array_distances(target, materials)
      good += data_array.min_by { |x| x[:distance] }[:id].to_s
    end
    good.to_i
  end

  def difficulty
    cropped_image = load_image(result_params[:result]).crop('57x12+285+51')
    target = pixels_array(cropped_image, 19, 4)
    data_array = array_distances(target, Material.where(style: 3).pluck(:pixels, :number))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def random_option
    cropped_image = load_image(result_params[:result]).crop('26x18+437+309')
    target = pixels_array(cropped_image, 13, 9)
    data_array = array_distances(target, Material.where(style: 5).pluck(:pixels, :number))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def gauge_option
    cropped_image = load_image(result_params[:result]).crop('26x18+396+309')
    target = pixels_array(cropped_image, 13, 9)
    data_array = array_distances(target, Material.where(style: 5).pluck(:pixels, :number))
    data_array.min_by { |x| x[:distance] }[:id]
  end

  def gauge_amount
    materials = Material.where(style: 6).pluck(:pixels, :number)
    24.downto(1) do |i|
      cropped_image = load_image(result_params[:result]).crop("5x5+#{263 + i * 13}+158")
      target = pixels_array(cropped_image, 5,5)
      data_array = array_distances(target, materials)
      if data_array.min_by { |x| x[:distance] }[:id] == 1
        return i
      end
    end
    0
  end

  def medal(gauge, good, bad, option)
    if bad == 0
      if good == 0
        'perfect'
      elsif good <= 5
        'fc_star'
      elsif good <= 20
        'fc_square'
      else
        'fc_circle'
      end
    elsif gauge >= 17
      if option == 'easy'
        'clear_easy'
      elsif bad <= 5
        'clear_star'
      elsif bad <= 20
        'clear_square'
      else
        'clear_circle'
      end
    elsif option != 'easy'
      if gauge >= 15
        'fail_star'
      elsif gauge >= 12
        'fail_square'
      else
        'fail_circle'
      end
    else
    'fail_circle'
    end
  end
end
