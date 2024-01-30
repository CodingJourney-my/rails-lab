class ArticlesController < ApplicationController

  def index
    @articles = Article.all.includes(:videos, :survey)
    article = @articles.first
    @durations = @articles.map do |article|
      video = article.videos.first
      api = Vimeo::Api.new(video.uid)
      duration = api.get_video_duration
    end
  end

  def show
    @article = Article.find_by(id: params[:id])
  end

end
