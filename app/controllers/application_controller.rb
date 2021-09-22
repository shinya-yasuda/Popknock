class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login
  before_action :set_current_user

  private

  def set_current_user
    User.current_user = current_user
  end
end
