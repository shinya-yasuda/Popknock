class Admin::InformationController < Admin::BaseController
  before_action :set_information, only: %i[edit update destroy]
  def index
    @information_list = Information.limit(5).order(updated_at: :desc)
  end

  def new
    @information = Information.new
  end

  def create
    @information = Information.new(information_params)
    if @information.save
      redirect_to admin_information_index_path, success: 'お知らせを追加しました'
    else
      flash.now[:danger] = 'お知らせを追加出来ませんでした'
      render :new
    end
  end

  def edit; end

  def update
    if @information.update(information_params)
      redirect_to admin_information_index_path, success: 'お知らせを更新しました'
    else
      flash.now[:danger] = 'お知らせを更新出来ませんでした'
      render :edit
    end
  end

  def destroy
    @information.destroy!
    redirect_to admin_information_index_path, success: 'お知らせを削除しました'
  end

  private

  def information_params
    params.require(:information).permit(:title, :body)
  end

  def set_information
    @information = Information.find(params[:id])
  end
end
