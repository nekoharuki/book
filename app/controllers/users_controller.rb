class UsersController < ApplicationController
  def index
    @users=User.all
  end
  def new
  end

  def create
    @user=User.new(name: params[:name],email: params[:email],address: params[:address],password: params[:password])
    if @user.save
      flash[:notice]="ユーザー登録完了しました"
      redirect_to("/users/index")
    else
      render("users/new")
    end
  end

  def edit
    @user=User.find_by(id: params[:id]);
  end

  def update
    @user=User.find_by(id: params[:id])
    @user.name=params[:name]
    @user.email=params[:email]
    @user.password=params[:password]
    @user.address=params[:address]
    if @user.save
      flash[:notice]="ユーザー情報編集できました"
      redirect_to("/users/index")
    else
      render("users/edit")
    end
  end

  def destroy
    @user=User.find_by(id: params[:id]);
    if @user.destroy
      flash[:notice]="ユーザー情報削除できました"
      redirect_to("/users/index")
    end
  end
  def show
    @user=User.find_by(id: params[:id]);
  end
end
