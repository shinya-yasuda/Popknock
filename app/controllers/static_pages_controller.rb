class StaticPagesController < ApplicationController
  def home
    @information_list = Information.all
  end
end
