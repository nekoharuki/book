class ApplicationController < ActionController::Base
  before_action :set_current_user

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
    user=User.find_by(id: params[:id])
    if @current_user.id!=user.id
      flash[:notice]="あなたはそのページに行けません"
      redirect_to("/items/index")
    end
  end

  def real_item
    item=Item.find_by(id: params[:id])
    if @current_user.id!=item.user.id
      flash[:notice]="あなたはそのページに行けません"
      redirect_to("/items/index")
    end
  end

end
