class PagesController < ApplicationController
  before_action :authenticate_user!
  def home
  end

  def rating
    @users = User.all
  end
end
