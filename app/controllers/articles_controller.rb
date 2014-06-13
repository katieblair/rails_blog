class ArticlesController < ApplicationController
  def index
    @articles = Article.order('created_at DESC')
  end

  def new
    @categories = Category.all
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @categories = Category.all

    if @article.save
      params[:article][:category_ids].each do |category_id|
        category = Category.find(category_id) unless category_id == ""
        Categorization.create(article: @article,
          category: category)
      end

      redirect_to '/articles'
    else
      flash.now[:notice] = "Uh oh!  Your blog post could not be saved."

      render :new
    end
  end

  def show
    @article = Article.find(params[:id])
    @comment = Comment.new
  end

  private

  def article_params
    params.require(:article).permit(:title, :author, :body)
  end
end
