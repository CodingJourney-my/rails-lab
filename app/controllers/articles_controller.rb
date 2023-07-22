class ArticlesController < ApplicationController

  def index
    @articles = Article.all.includes(:videos, :survey)
  end

  def show
    @article = Article.find_by(id: params[:id])
  end

end
