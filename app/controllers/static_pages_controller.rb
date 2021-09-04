class StaticPagesController < ApplicationController
  skip_before_action :require_login
  def home
    @information_list = Information.all
  end
end
