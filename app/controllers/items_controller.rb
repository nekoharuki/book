class ItemsController < ApplicationController

  before_action :please_login, only: [:edit, :create, :new, :update, :destroy, :show, :index,:category,:categorize,:like]
  before_action :real_item, only: [:edit, :update, :destroy,:destroy_form]
  before_action :category_not, only: [:category]

  def index
    @items = Item.all
  end

  def show
    @item = Item.find_by(id: params[:id])
    @reviews=Review.where(item_id: @item.id)
  end

  def new
  end

  def create
    @item = Item.new(
      name: params[:name],
      author: params[:author],
      publisher: params[:publisher],
      content: params[:content],
      situation: params[:situation],
      category: params[:category],
      image: params[:image],
      user_id: @current_user.id
    )
    if @item.save
      flash[:notice] = "登録できました"
      redirect_to("/items/index")
    else
      render("items/new")
    end
  end

  def edit
    @item = Item.find_by(id: params[:id])
  end

  def update
    @item = Item.find_by(id: params[:id])
    @item.name = params[:name]
    @item.author = params[:author]
    @item.publisher = params[:publisher]
    @item.content = params[:content]
    @item.situation = params[:situation]
    @item.category = params[:category]
    @item.image = params[:image]
    if @item.save
      flash[:notice] = "編集できました"
      redirect_to("/items/index")
    else
      render("items/edit")
    end
  end

  def destroy
    @item = Item.find_by(id: params[:id])
    if @item.destroy
      flash[:notice] = "削除できました"
      redirect_to("/items/index")
    end
  end

  def destroy_form
    @item = Item.find_by(id: params[:id])
  end

  def category
    @category_name = params[:category]
    @items = Item.where(category: @category_name)
  end

  def categorize
    @categorize = Item.select(:category).distinct.pluck(:category)
  end

  def like
    @likes=Like.where(user_id: @current_user.id)
  end

  def category_not
    flag=0;
    categories = Item.pluck(:category)
    categories.each do |category|
      if category == params[:category]
        flag=1;
      end
    end
      if flag==0
        flash[:notice] = "そのカテゴリーはありません"
        redirect_to("/items/categorize");
      end
  end
end
