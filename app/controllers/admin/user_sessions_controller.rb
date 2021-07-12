class Admin::UserSessionsController < Admin::BaseController
  layout 'admin/layouts/application'
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:danger] = 'Login Failed.'
      render :new
    end
  end

  def destroy
    logout
    redirect_to admin_login_path
  end
end
