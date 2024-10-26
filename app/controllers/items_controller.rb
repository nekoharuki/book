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
    @trades=Trade.where(sell_item_id: @item.id)
  end

  def new
    @item = Item.new
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
      help_point: params[:help_point],
      recommend_point: params[:recommend_point],
      learn_point: params[:learn_point],
      user_id: @current_user.id
    )

    if @item.save
      flash[:notice] = "登録できました"
      redirect_to("/items/index")
    else
      flash[:alert] = "登録できませんでした"
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
    @item.help_point = params[:help_point],
    @item.recommend_point = params[:recommend_point],
    @item.learn_point = params[:learn_point]

    image_url = @item.image.url
    @item.image = params[:image]

    if @item.save
      public_id = image_url.split('/').last.split('.').first
      Cloudinary::Uploader.destroy(public_id)
      flash[:notice] = "編集できました"
      redirect_to("/items/index")
    else
      flash[:alert] = "編集できませんでした"
      render("items/edit")
    end
  end

  def destroy
    @item = Item.find_by(id: params[:id])
    if @item.destroy
      flash[:notice] = "削除できました"
      redirect_to("/items/index")
    else
      flash[:alert]="削除できませんでした"
      redirect_to("/items/destroy_form")
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

  def user_items
    @items=Item.where(user_id: @current_user.id);
    @other_item=Item.find_by(id: params[:item_id])
  end

  def trade
    other_item=Item.find_by(id: params[:other_item_id])
    trade=Trade.new(buy_item_id: params[:my_item_id],buy_user_id: @current_user.id,sell_item_id: params[:other_item_id],sell_user_id: other_item.user.id)
    if trade.save
      flash[:notice]="物々交換リクエストできました"
      redirect_to("/items/#{other_item.id}");
    end
  end

  def detail
    detail=Detail.new(buy_item_id: params[:my_item_id],buy_user_id: @current_user.id,sell_item_id: params[:other_item_id],sell_user_id: other_item.user.id)
    if detail.save
      my_item=Item.find_by(id: params[:my_item_id])
      my_item.destroy
      other_item=Item.find_by(id: params[:other_item_id])
      other_item.destroy
    end
  end
end
