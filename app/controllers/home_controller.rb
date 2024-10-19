class HomeController < ApplicationController
  before_action :login_now,{only: [:top,:about]}

  def top
  end
  def about
  end
end
