class LikesController < ApplicationController
  before_action :please_login, only: [:create, :destroy]
  before_action :like_not, only: [:create, :destroy]

  def create
    item_id = HASHIDS.decode(params[:item_id]).first
    user_id = HASHIDS.decode(params[:user_id]).first
    like_check = Like.find_by(user_id: user_id, item_id: item_id)
    if like_check
      flash[:notice] = "もういいねされています"
      redirect_to("/items/index") and return
    else
      @like = Like.new(item_id: item_id, user_id: user_id)
      if @like.save
        flash[:notice] = "いいねできました"
        redirect_to("/items/index") and return
      else
        flash[:notice] = "いいねできませんでした"
        redirect_to("/items/index") and return
      end
    end
  end

  def destroy
    item_id = HASHIDS.decode(params[:item_id]).first
    user_id = HASHIDS.decode(params[:user_id]).first
    @like = Like.find_by(item_id: item_id, user_id: user_id)
    if @like
      if @like.destroy
        flash[:notice] = "いいねを削除できました"
        redirect_to("/items/index") and return
      else
        flash[:notice] = "いいねを削除できませんでした"
        redirect_to("/items/index") and return
      end
    else
      flash[:notice] = "まだいいねされていません"
      redirect_to("/items/index") and return
    end
  end

  def like_not
    item_id = HASHIDS.decode(params[:item_id]).first
    user_id = HASHIDS.decode(params[:user_id]).first
    if @current_user.id != user_id
      flash[:notice] = "いいねできません"
      redirect_to("/items/index") and return
    end
    @items = Item.where(user_id: user_id)
    @items.each do |item|
      if item.id == item_id
        flash[:notice] = "いいねできません"
        redirect_to("/items/index") and return
      end
    end
  end
end
