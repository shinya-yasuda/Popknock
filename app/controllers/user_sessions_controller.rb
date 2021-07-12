class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def new; end

  def create
    user = login(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_path
    else
      render :new
    end
  end
end
