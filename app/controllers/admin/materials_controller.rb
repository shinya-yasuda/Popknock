require 'image_process'
class Admin::MaterialsController < Admin::BaseController
  include ImageProcess
  before_action :set_material, only: %i[edit update destroy]
  def index
    @materials = Material.all
  end

  def new
    @material = Material.new
  end

  def create
    @material = Material.new(number: material_params[:number], style: material_params[:style], version: material_params[:version])
    @material.pixels = pixels_array(load_image(material_params[:image]), style_size[0], style_size[1])
    if @material.save
      redirect_to new_admin_material_path, success: '文字画像を追加しました'
    else
      flash.now[:danger] = '文字画像を追加できませんでした'
      render :new
    end
  end

  def edit; end

  def destroy
    @material.destroy!
    redirect_to admin_materials_path
  end

  private

  def material_params
    params.require(:material).permit(:number, :image, :style, :version)
  end

  def set_material
    @material = Material.find(params[:id])
  end

  def style_size
    sizes = { 'score' => [7, 7], 'bad' => [6, 8], 'good' => [6, 8], 'difficulty' => [19, 4], 'gauge_option' => [13, 9],
              'random' => [13, 9], 'gauge' => [5, 5], 'gauge_option_simple' => [5, 5], 'option_type' => [10, 5],
              'version' => [20, 5], 'date' => [6, 11] }
    sizes[material_params[:style]]
  end
end
