class ApplicationController < ActionController::Base
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_token
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login
  before_action :set_current_user

  private

  def set_current_user
    User.current_user = current_user
  end

  def invalid_token
    redirect_to root_path, danger: 'セッションが切れました'
  end
end
