class ItemsController < ApplicationController

  before_action :please_login
  before_action :real_item, only: [:edit, :update, :destroy, :destroy_form]
  before_action :category_not, only: [:category]
  before_action :author_not, only: [:author]
  before_action :publisher_not, only: [:publisher]
  before_action :trade_not, only: [:trade]
  before_action :detail_not, only: [:detail]

  def index
    @items = Item.where(status: [0, 1])
  end

  def new
    @item = Item.new
  end

  def show
    item_id = @hashids.decode(params[:id]).first
    @item = Item.find_by(id: item_id, status: [0, 1])
    if @item
      @reviews = Review.where(item_id: @item.id)
      @trades = Trade.where(item_requested_id: @item.id)
    else
      flash[:alert] = "アイテムが見つかりません"
      redirect_to items_path
    end
  end

  def create
    @item = Item.new(
      title: params[:title],
      author: params[:author],
      publisher: params[:publisher],
      content: params[:content],
      condition: params[:condition],
      category: params[:category],
      image: params[:image],
      help_point: params[:help_point],
      recommend_point: params[:recommend_point],
      learn_point: params[:learn_point],
      status: 0,
      user_id: @current_user.id
    )

    if @item.save
      flash[:notice] = "登録できました"
      redirect_to("/items")
    else
      flash[:alert] = "登録できませんでした"
      render("items/new")
    end
  end

  def edit
    item_id = @hashids.decode(params[:id]).first
    @item = Item.find_by(id: item_id, status: [0, 1])
  end

  def update
    item_id = @hashids.decode(params[:id]).first
    @item = Item.find_by(id: item_id)
    @item.title = params[:title]
    @item.author = params[:author]
    @item.publisher = params[:publisher]
    @item.content = params[:content]
    @item.condition = params[:condition]
    @item.category = params[:category]
    @item.help_point = params[:help_point]
    @item.recommend_point = params[:recommend_point]
    @item.learn_point = params[:learn_point]
    image_url = @item.image.url
    @item.image = params[:image]

    if @item.save
      public_id = image_url.split('/').last.split('.').first
      Cloudinary::Uploader.destroy(public_id)
      flash[:notice] = "編集できました"
      redirect_to("/items")
    else
      flash[:alert] = "編集できませんでした"
      render("items/edit")
    end
  end

  def destroy
    item_id = @hashids.decode(params[:id]).first
    @item = Item.find_by(id: item_id, status: [0, 1])
    if @item.destroy
      flash[:notice] = "削除できました"
      redirect_to("/items")
    else
      flash[:alert] = "削除できませんでした"
      redirect_to("/items/destroy_form")
    end
  end

  def destroy_form
    item_id = @hashids.decode(params[:id]).first
    @item = Item.find_by(id: item_id, status: [0, 1])
  end

  def category
    @category_name = params[:category]
    @items = Item.where(category: params[:category], status: [0, 1])
  end


  def like
    @likes = Like.where(user_id: @current_user.id)
  end

  def category_not
    flag = 0
    categorize = Item.select(:category).distinct.pluck(:category)
    categorize.each do |category|
      if category == params[:category]
        flag = 1
      end
    end
    if flag == 0
      flash[:notice] = "そのカテゴリーはありません"
      redirect_to("/items/categorize")
    end
  end

  def trade_items
    if @current_user.address == nil
      flash[:alert] = "住所を登録してください"
      redirect_to("/users/#{@hashids.encode(@current_user.id)}/edit")
    end
    @items = Item.where(user_id: @current_user.id, status: 0)
    item_id = @hashids.decode(params[:id]).first
    @item_requested = Item.find_by(id: item_id, status: [0, 1])
  end

  def trade
    item_requested_id = @hashids.decode(params[:item_requested_id]).first
    item_offered_id = @hashids.decode(params[:item_offered_id]).first
    item_requested = Item.find_by(id: item_requested_id, status: [0, 1])
    item_offered = Item.find_by(id: item_offered_id, status: [0, 1])
    trade = Trade.new(
      item_requested_id: item_requested.id,
      user_requested_id: item_requested.user.id,
      item_offered_id: item_offered.id,
      user_offered_id: item_offered.user.id
    )
    if trade.save
      item_requested.status = 1
      item_offered.status = 1
      item_requested.save
      item_offered.save
      flash[:notice] = "物々交換リクエストできました"
      redirect_to("/items/#{@hashids.encode(item_requested.id)}")
    else
      flash[:alert] = "物々交換リクエストに失敗しました"
      redirect_to("/items/#{@hashids.encode(item_requested.id)}/user_items")
    end
  end

  def detail
    item_requested_id = @hashids.decode(params[:item_requested_id]).first
    item_offered_id = @hashids.decode(params[:item_offered_id]).first
    item_requested = Item.find_by(id: item_requested_id, status: 1)
    item_offered = Item.find_by(id: item_offered_id, status: 1)

    detail = Detail.new(
      item_requested_id: item_requested.id,
      user_requested_id: item_requested.user.id,
      item_offered_id: item_offered.id,
      user_offered_id: item_offered.user.id
    )

    if detail.save
      item_requested.status = 2
      item_offered.status = 2
      item_requested.save
      item_offered.save

      trade = Trade.find_by(item_requested_id: detail.item_requested_id,
                            user_requested_id: detail.user_requested_id,
                            item_offered_id: detail.item_offered_id,
                            user_offered_id: detail.user_offered_id)

      if trade.destroy
        flash[:notice] = "物々交換できました"
        redirect_to("/items")
      else
        flash[:alert] = "物々交換できませんでした"
        redirect_to("/items")
      end
    else
      flash[:alert] = "物々交換できませんでした"
      redirect_to("/items")
    end
  end

  def details
    @items_offered = Detail.where(user_offered_id: @current_user.id)
    @items_requested = Detail.where(user_requested_id: @current_user.id)
  end

  def traded
    item_id = @hashids.decode(params[:id]).first
    @item = Item.find_by(id: item_id, status: 2)
  end

  def publisher
    @publisher = params[:publisher]
    @items = Item.where(publisher: params[:publisher], status: [0, 1])
  end

  def author
    @author = params[:author]
    @items = Item.where(author: params[:author], status: [0, 1])
  end


  def author_not
    flag = 0
    authors = Item.select(:author).distinct.pluck(:author)
    authors.each do |author|
      if author == params[:author]
        flag = 1
      end
    end
    if flag == 0
      flash[:notice] = "その作者のページはありません"
      redirect_to("/items/authors")
    end
  end

  def publisher_not
    flag = 0
    publishers = Item.select(:publisher).distinct.pluck(:publisher)
    publishers.each do |publisher|
      if publisher == params[:publisher]
        flag = 1
      end
    end
    if flag == 0
      flash[:notice] = "その出版社のページはありません"
      redirect_to("/items/publishers")
    end
  end

  def trade_not
    item_requested_id = @hashids.decode(params[:item_requested_id]).first
    item_offered_id = @hashids.decode(params[:item_offered_id]).first
    item_requested = Item.find_by(id: item_requested_id, status: [0, 1])
    item_offered = Item.find_by(id: item_offered_id, status: [0, 1])
    if item_offered.user.id != @current_user.id
      flash[:alert] = "物々交換リクエストに失敗しました"
      redirect_to("/items")
    end
    if item_requested.user.id == item_offered.user.id
      flash[:alert] = "物々交換リクエストに失敗しました"
      redirect_to("/items")
    end
    if item_requested.id == item_offered.id
      flash[:alert] = "物々交換リクエストに失敗しました"
      redirect_to("/items")
    end
  end

  def detail_not
    item_requested_id = @hashids.decode(params[:item_requested_id]).first
    item_offered_id = @hashids.decode(params[:item_offered_id]).first
    item_requested = Item.find_by(id: item_requested_id, status: [0, 1])
    item_offered = Item.find_by(id: item_offered_id, status: [0, 1])

    trade = Trade.find_by(item_requested_id: item_requested.id,
                          user_requested_id: item_requested.user.id,
                          item_offered_id: item_offered.id,
                          user_offered_id: item_offered.user.id
                          )

    if !trade
      flash[:alert] = "物々交換できませんでした"
      redirect_to("/items")
    end
    if item_requested.user.id != @current_user.id
      flash[:alert] = "物々交換できませんでした"
      redirect_to("/items")
    end
    if item_requested.user.id == item_offered.user.id
      flash[:alert] = "物々交換できませんでした"
      redirect_to("/items")
    end
    if item_requested.id == item_offered.id
      flash[:alert] = "物々交換できませんでした"
      redirect_to("/items")
    end
  end

def search
    @categorize = Item.select(:category).distinct.pluck(:category)
    @publishers = Item.select(:publisher).distinct.pluck(:publisher)
    @authors = Item.select(:author).distinct.pluck(:author)
end
def title_search
  @title_name = params[:title_search]
  redirect_to("/items/title_results/#{@title_name}")
end
  def title_results
    @title_name=params[:title_name]
    @items = Item.where(title: params[:title_name], status: [0, 1])
  end
end
