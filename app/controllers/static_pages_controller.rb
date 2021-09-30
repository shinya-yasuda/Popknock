class StaticPagesController < ApplicationController
  skip_before_action :require_login
  def home
    @information_list = Information.limit(5).order(updated_at: :desc)
  end
end
