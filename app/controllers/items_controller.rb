class ItemsController < ApplicationController

  before_action :please_login
  before_action :real_item, only: [:edit, :update, :destroy]
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

    if params[:image].present?
      @item.image = params[:image]
    end

    if @item.save
      if params[:image].present?
        public_id = image_url.split('/').last.split('.').first
        Cloudinary::Uploader.destroy(public_id)
      end
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
      redirect_to("/items")
    end
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
      user_offered_id: item_offered.user.id,
      user_offered_status: 0,
      user_requested_status: 0
    )

    if detail.save
      item_requested.status = 2
      item_offered.status = 2
      item_requested.save
      item_offered.save

      trade = Trade.find_by(item_requested_id: detail.item_requested_id,
                            user_requested_id: detail.user_requested_id,
                            item_offered_id: detail.item_offered_id,
                            user_offered_id: detail.user_offered_id
                            )

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
      redirect_to("/items") and return
    end
    if item_requested.user.id == item_offered.user.id
      flash[:alert] = "物々交換リクエストに失敗しました"
      redirect_to("/items") and return
    end
    if item_requested.id == item_offered.id
      flash[:alert] = "物々交換リクエストに失敗しました"
      redirect_to("/items") and return
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
                          user_offered_id: item_offered.user.id)

    if !trade
      flash[:alert] = "物々交換できませんでした"
      redirect_to("/items") and return
    end
    if item_requested.user.id != @current_user.id
      flash[:alert] = "物々交換できませんでした"
      redirect_to("/items") and return
    end
    if item_requested.user.id == item_offered.user.id
      flash[:alert] = "物々交換できませんでした"
      redirect_to("/items") and return
    end
    if item_requested.id == item_offered.id
      flash[:alert] = "物々交換できませんでした"
      redirect_to("/items") and return
    end
  end

  def search
    @categorize = Item.select(:category).distinct.pluck(:category)
    @publishers = Item.select(:publisher).distinct.pluck(:publisher)
    @authors = Item.select(:author).distinct.pluck(:author)
  end

  def title_search
    @title_name = params[:title_name]
    redirect_to url_for(controller: 'items', action: 'title_results', title_name: @title_name)
  end

  def title_results
    @title_name = params[:title_name]
    @items = Item.where("title LIKE ? AND status IN (?)", "%#{@title_name}%", [0, 1])
  end

  def delivery
    my_id = @hashids.decode(params[:myitem]).first
    you_id = @hashids.decode(params[:youitem]).first
    @number = @hashids.decode(params[:number]).first
    if !(@number == 1 || @number == 2)
      flash[:alert] = "無効な番号です"
      redirect_to("/items")
    end
    @myitem = Item.find_by(id: my_id)
    if @myitem.user.id!=@current_user.id
      flash[:alert] = "そのページには行けません"
      redirect_to("/items")
    end
    @youitem = Item.find_by(id: you_id)

  end

  def delivery_success
    @number = @hashids.decode(params[:number]).first
    @myitem_id = @hashids.decode(params[:myitem_id]).first
    @youitem_id = @hashids.decode(params[:youitem_id]).first
    if @number == 1
      @detail = Detail.find_by(item_offered_id: @myitem_id)
      if @detail
        @detail.user_offered_status = 1
        @detail.save
      end
    elsif @number == 2
      @detail = Detail.find_by(item_requested_id: @myitem_id)
      if @detail
        @detail.user_requested_status = 1
        @detail.save
      end
    else
      flash[:alert] = "無効な番号です"
      redirect_to("/items") and return
    end
    flash[:notice] = "配送完了しました"
    redirect_to("/items/delivery/#{@hashids.encode(@number)}/#{@hashids.encode(@myitem_id)}/#{@hashids.encode(@youitem_id)}")
  end

end
