class LikesController < ApplicationController
  def create
    @like=Like.new(item_id: params[:item_id],user_id: params[:user_id])
    if @like.save
      flash[:notice]="いいねできました"
      redirect_to("/items/index");
    end
  end


  def destroy
    @like=Like.find_by(item_id: params[:item_id],user_id: params[:user_id])
    if @like.destroy
      flash[:notice]="いいねを削除できました"
      redirect_to("/items/index");
    end
  end
end
