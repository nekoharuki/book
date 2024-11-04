class ReviewsController < ApplicationController
  before_action :please_login, only: [:create, :update, :destroy, :edit]
  before_action :review_not, only: [:edit, :update, :destroy]
  before_action :create_not, only: [:create]

  def create
    item_id = HASHIDS.decode(params[:item_id]).first
    @review = Review.new(
      point: params[:point],
      comment: params[:comment],
      user_id: @current_user.id,
      item_id: item_id
    )
    if @review.save
      flash[:notice] = "レビューできました"
      redirect_to("/items/#{HASHIDS.encode(@review.item_id)}") and return
    else
      flash[:alert] = "レビューできませんでした"
      @point = params[:point]
      @comment = params[:comment]
      render("items/show") and return
    end
  end

  def edit
    review_id = HASHIDS.decode(params[:id]).first
    @review = Review.find_by(id: review_id)
  end

  def update
    review_id = HASHIDS.decode(params[:id]).first
    @review = Review.find_by(id: review_id)
    @review.point = params[:point]
    @review.comment = params[:comment]
    if @review.save
      flash[:notice] = "レビュー編集できました"
      redirect_to("/items/#{HASHIDS.encode(@review.item_id)}") and return
    else
      flash[:alert] = "レビュー編集できませんでした"
      @point = params[:point]
      @comment = params[:comment]
      render("items/show") and return
    end
  end

  def destroy
    review_id = HASHIDS.decode(params[:id]).first
    @review = Review.find_by(id: review_id)
    if @review.destroy
      flash[:notice] = "レビューを削除できました"
      redirect_to("/items/#{HASHIDS.encode(@review.item_id)}") and return
    end
  end

  def review_not
    review_id = HASHIDS.decode(params[:id]).first
    review = Review.find_by(id: review_id)
    if review.user_id != @current_user.id
      flash[:notice] = "あなたはそのページには行けません"
      redirect_to("/items/#{HASHIDS.encode(review.item_id)}") and return
    end
  end

  def create_not
    item_id = HASHIDS.decode(params[:item_id]).first
    items = Item.where(user_id: @current_user.id)
    items.each do |item|
      if item.id == item_id
        flash[:notice] = "レビューを投稿できません"
        redirect_to("/items/#{HASHIDS.encode(item_id)}") and return
      end
    end
  end
end
