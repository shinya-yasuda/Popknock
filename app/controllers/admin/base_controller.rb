class Admin::BaseController < ApplicationController
  layout 'admin/layouts/application'
  before_action :require_admin

  private

  def require_admin
    redirect_to root_path, danger: '権限がありません' unless current_user&.admin?
  end
end
