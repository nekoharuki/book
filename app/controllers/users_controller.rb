class UsersController < ApplicationController
  before_action :please_login, only: [:edit, :logout, :update, :destroy, :show, :index, :user_items,:follows_create,:follows_destroy,:follows_find,:follows]
  before_action :login_now, only: [:login, :login_form, :create, :new]
  before_action :real_user, only: [:edit, :update, :destroy, :show]
  before_action :follows_find, only: [:follows_create]
  before_action :follow_current, only: [:follows_create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      address: params[:address],
      password: params[:password]
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録完了しました"
      redirect_to("/items")
    else
      @name = params[:name]
      @address = params[:address]
      @password = params[:password]
      flash[:alert] = "ユーザー登録できませんでした"
      render("users/new")
    end
  end

  def edit
    user_id = @hashids.decode(params[:id]).first
    @user = User.find_by(id: user_id)
  end

  def update
    user_id = @hashids.decode(params[:id]).first
    @user = User.find_by(id: user_id)
    @user.name = params[:name]
    @user.email = params[:email]
    @user.address = params[:address]
    if @user.save
      flash[:notice] = "ユーザー情報編集できました"
      redirect_to("/users")
    else
      flash[:alert] = "ユーザー情報編集できませんでした"
      render("users/edit")
    end
  end

  def destroy
    user_id = @hashids.decode(params[:id]).first
    @user = User.find_by(id: user_id)
    if @user
      session[:user_id] = nil
      @user.destroy
      flash[:notice] = "ユーザー情報削除できました"
      redirect_to("/login")
    else
      flash[:alert] = "ユーザー情報削除できませんでした"
      redirect_to("/users")
    end
  end


  def show
    user_id = @hashids.decode(params[:id]).first
    @user = User.find_by(id: user_id)
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインできました"
      redirect_to("/items")
    else
      flash[:alert] = "メールアドレスまたはパスワードが間違っています"
      @password = params[:password]
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
    user_id = @hashids.decode(params[:id]).first
    @items = Item.where(user_id: user_id, status: [0, 1])
    @user = User.find_by(id: user_id)
  end

  def follows_create
    followed_user_id = @hashids.decode(params[:id]).first
    @follows=Follow.new
    @follows.follower_user=@current_user.id
    @follows.followed_user=followed_user_id
    if @follows.save
      flash[:notice]="フォローできました"
      redirect_to("/users/#{@hashids.encode(followed_user_id)}/items")
    end
  end

  def follows_destroy
    followed_user_id = @hashids.decode(params[:id]).first
    follow=Follow.find_by(follower_user: @current_user.id,followed_user: followed_user_id)
    if follow.destroy
      flash[:notice]="フォロー解除できました"
      redirect_to("/users/#{@hashids.encode(followed_user_id)}/items")
    end
  end

  def follows_find
    followed_user_id = @hashids.decode(params[:id]).first
    if follow=Follow.find_by(follower_user: @current_user.id,followed_user: followed_user_id)
      flash[:notice]="すでにフォローされています"
      redirect_to("/users/#{@hashids.encode(followed_user_id)}/items")
    end
  end

  def follow_current
    followed_user_id = @hashids.decode(params[:id]).first
    if followed_user_id==@current_user.id
      flash[:notice]="フォローできません"
      redirect_to("/users/#{@hashids.encode(followed_user_id)}/items")
    end
  end
  def  follows
    @followeds=Follow.where(follower_user: @current_user.id)
  end
end
