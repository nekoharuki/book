class UsersController < ApplicationController
  before_action :please_login, {only: [:edit, :logout, :update, :destroy, :show, :index,:destroy_form,:user_items]}
  before_action :login_now, {only: [:login, :login_form, :create, :new]}
  before_action :real_user, {only: [:edit, :update, :destroy, :show,:destroy_form]}

  def index
    @users = User.all
  end

  def new
  end

  def create
    @user = User.new(name: params[:name], email: params[:email], address: params[:address], password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録完了しました"
      redirect_to("/items/index")
    else
      @name=params[:name]
      @email=params[:email]
      @address=params[:address]
      @password=params[:password]
      flash[:alert]="ユーザー登録できませんでした"
      render("users/new")
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.address = params[:address]
    if @user.save
      flash[:notice] = "ユーザー情報編集できました"
      redirect_to("/users/index")
    else
      render("users/edit")
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user
      session[:user_id] = nil
      @user.destroy
      flash[:notice] = "ユーザー情報削除できました"
      redirect_to("/")
    end
  end
  def destroy_form
    @user = User.find_by(id: params[:id])
  end
  def show
    @user = User.find_by(id: params[:id])
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインできました"
      redirect_to("/items/index")
    else
      flash[:alert]="メールアドレスまたはパスワードが間違っています"
      @email=params[:email]
      @password=params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def login_form
  end

  def user_items
    @items=Item.where(user_id: params[:id])
    @user=User.find_by(id:params[:id])
  end

end
