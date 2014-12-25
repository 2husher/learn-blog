class CommentsController < ApplicationController
  before_filter :authenticate, only: :destroy

  def new
    @article = Article.find(params[:article_id])
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @article, notice: 'Thanks for your comment' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @article, alert: 'Unable to add comment' }
        format.js { render 'fail_create.js' }
      end
    end
  end

  def destroy
    @article = current_user.articles.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @article, notice: 'Comment Deleted' }
      format.js
    end
  end

  private

    def comment_params
      params[:comment].permit(:name, :email, :body)
    end
end