class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_admin, only: %i[new create]
  skip_before_action :require_login, only: %i[new create]
  layout 'admin/layouts/application'
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    redirect_to admin_login_path
  end
end
