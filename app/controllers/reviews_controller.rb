class ReviewsController < ApplicationController
  def create
    @review=Review.new(point: params[:point],comment: params[:comment],user_id: @current_user.id,item_id: params[:item_id])
    if @review.save
      flash[:notice]="レビューできました"
      redirect_to("/items/#{@review.item_id}")
    end
  end

  def edit
    @review=Review.find_by(id: params[:id])
  end

  def update
    @review=Review.find_by(id: params[:id])
    @review.point=params[:point]
    @review.comment=params[:comment]
    if @review.save
      flash[:notice]="評価編集できました"
      redirect_to("/items/#{@review.item_id}")
    end
  end
  def destroy
    @review=Review.find_by(id: params[:id])
    if @review.destroy
      flash[:notice]="投稿を削除できました"
      redirect_to("/items/#{@review.item_id}")
    end
  end
end
