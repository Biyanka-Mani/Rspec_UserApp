class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def create
    if @article.user == current_user
      flash[:alert] = "You cannot like your own article."
    else
      @like = @article.likes.new(user: current_user)

      if @like.save
        flash[:notice] = "Article liked."
      else
        flash[:alert] = "Unable to like article."
      end
    end
    redirect_to @article
  end

  def destroy
    @like = @article.likes.find_by(user: current_user)

    if @like
      @like.destroy
      flash[:notice] = "Article unliked."
    else
      flash[:alert] = "You have not liked this article."
    end
    redirect_to @article
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end
end

