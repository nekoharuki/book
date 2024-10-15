class HomeController < ApplicationController
  before_action :login_now,{only: [:top]}

  def top
  end
end
