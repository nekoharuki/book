class LikesController < ApplicationController
  before_action :like_not, only: [:create, :destroy]

  def create
    like_check=Like.find_by(user_id: params[:user_id],item_id: params[:item_id])
    if like_check
      flash[:notice]="もういいねされています"
      redirect_to("/items/index")
    else
      @like = Like.new(item_id: params[:item_id], user_id: params[:user_id])
      if @like.save
        flash[:notice] = "いいねできました"
        redirect_to("/items/index")
      else
        flash[:notice] = "いいねできませんでした"
        redirect_to("/items/index")
      end
    end
  end

  def destroy
    @like = Like.find_by(item_id: params[:item_id], user_id: params[:user_id])
    if @like
      if @like.destroy
        flash[:notice]="いいねを削除できました"
        redirect_to("/items/index")
      else
        flash[:notice]="いいねを削除できませんでした"
        redirect_to("/items/index")
      end
    else
      flash[:notice] = "まだいいねされていません"
      redirect_to("/items/index")
    end
  end

  def like_not
    if @current_user.id != params[:user_id].to_i
      flash[:notice] = "いいねできません"
      redirect_to("/items/index")
    end
    @items=Item.where(user_id: params[:user_id])
    @items.each do |item|
      if item.id==params[:item_id].to_i
        flash[:notice]="いいねできません"
        redirect_to("/items/index")
      end
    end
  end

end
