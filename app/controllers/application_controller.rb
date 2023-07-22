class ApplicationController < ActionController::Base
  before_action :set_current_user

  def set_current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !@current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # unless Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound,   with: :render_404
    rescue_from ActionController::RoutingError do |exception|
      return render_429 if exception.message == "login"
      return render_404
    end
  # end

  def routing_error
    raise ActionController::RoutingError, params[:not_found]
  end

  private
    def render_404(e = nil)
      logger.info "Rendering 404 with excaption: #{e.message}" if e

      if request.format.to_sym == :json
        render json: { error: "404 Not Found" }, status: :not_found
      else
        render "errors/404.html.erb", status: :not_found, layout: "error"
      end
    end

    def render_429(e = nil)
      logger.error "Rendering 429 with excaption: #{e.message}" if e

      if request.format.to_sym == :json
        render json: { error: "429 Too Many Requests" }, status: :too_many_requests
      else
        render "errors/429.html.erb", status: :too_many_requests, layout: "error"
      end
    end
end
