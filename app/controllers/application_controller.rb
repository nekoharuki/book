class ApplicationController < ActionController::Base
  before_action :set_current_user
  skip_before_action :verify_authenticity_token

  def set_current_user
    @current_user=User.find_by(id: session[:user_id]);
  end

  def please_login
    if @current_user==nil
      flash[:notice]="ログインしてください"
      redirect_to("/login")
    end
  end

  def login_now
    if @current_user
      flash[:notice]="現在ログインしています"
      redirect_to("/items/index")
    end
  end

  def real_user
    user_id=HASHIDS.decode(params[:id]).first
    if @current_user.id!=user_id.to_i
      flash[:notice]="あなたはそのページに行けません"
      redirect_to("/items/index")
    end
  end

  def real_item
    item_id=HASHIDS.decode(params[:id]).first
    item=Item.find_by(id: item_id)
    if @current_user.id!=item.user.id.to_i
      flash[:notice]="あなたはそのページに行けません"
      redirect_to("/items/index")
    end
  end

end
