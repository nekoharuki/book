# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :initialize_hashids
  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def please_login
    if @current_user.nil?
      flash[:notice] = "ログインしてください"
      redirect_to("/login")
    end
  end

  def login_now
    if @current_user
      flash[:notice] = "現在ログインしています"
      redirect_to("/items")
    end
  end

  def real_user
    user_id = @hashids.decode(params[:id]).first
    if @current_user.id != user_id
      flash[:notice] = "あなたはそのページに行けません"
      redirect_to("/items")
    end
  end

  def real_item
    item_id = @hashids.decode(params[:id]).first
    item = Item.find_by(id: item_id)
    if @current_user.id != item.user.id
      flash[:notice] = "あなたはそのページに行けません"
      redirect_to("/items")
    end
  end

  private

  def initialize_hashids
    @hashids = Hashids.new("kikotixyannkawaii", 20)
  end
end
