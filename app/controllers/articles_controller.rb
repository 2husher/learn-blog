class ArticlesController < ApplicationController
  before_action :authenticate, except: [:index, :show]
  before_action :set_current_user_article, only: [:edit, :update, :destroy]
  before_action :set_article, only: [:show, :notify_friend]

  def index
    @articles = Article.all
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url
  end

  def notify_friend
    Notifier.email_friend(@article, params[:name], params[:email]).deliver
    redirect_to @article, notice: "Successfully sent a message to your friend"
  end

  private
    def article_params
      params[:article].permit(:title, :location, :excerpt, :body, :published_at, category_ids: [])
    end

    def set_article
      @article = Article.find(params[:id])
    end

    def set_current_user_article
      @article = current_user.articles.find(params[:id])
    end
end
