class Api::UsersController < BaseController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
    count = @users.count
    render_data @users, total: count
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
    render_data @user
  end
end
