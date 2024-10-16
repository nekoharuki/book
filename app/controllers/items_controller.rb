class ItemsController < ApplicationController

  before_action :please_login,{only: [:edit,:create,:new,:update,:destroy,:show,:index]}
  before_action :real_item,{only: [:edit,:update,:destroy]}

  def index
    @items=Item.all;
  end

  def show
    @item=Item.find_by(id: params[:id]);
  end
  def new
  end

  def create
    @item=Item.new(name: params[:name],
    author: params[:author],
    publisher: params[:publisher],
    content: params[:content],
    situation: params[:situation],
    category: params[:category],
    image: params[:image],
    user_id: @current_user.id
    )
    if @item.save
      flash[:notice]="登録できました"
      redirect_to("/items/index");
    else
      render("items/new")
    end
  end


  def edit
    @item=Item.find_by(id: params[:id])
  end
  def update
    @item=Item.find_by(id: params[:id])
    @item.name=params[:name]
    @item.author=params[:author]
    @item.publisher=params[:publisher]
    @item.content=params[:content]
    @item.situation=params[:situation]
    @item.category=params[:category]
    @item.image=params[:image]
    if @item.save
      flash[:notice]="編集できました"
      redirect_to("/items/index");
    else
        render("items/edit")
    end
  end
def destroy
  @item=Item.find_by(id: params[:id])
  if @item.destroy
    flash[:notice]="削除できました"
    redirect_to("/items/index");
  else
    render("items/show")
  end
end

def category
  @category_name=params[:category]
  @items=Item.where(category: @category_name)
end
def categorize
  @categorys = Item.select(:category).distinct.pluck(:category)
end
end
