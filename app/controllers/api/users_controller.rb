class Api::UsersController < BaseController
  def index
    @subjects = User.all
    @subjects = @subjects.limit(current_limit).offset(current_offset).order(id: :desc)
    total = @subjects.count
    render_data @subjects.map{|x| User::ApiSerializer.new(x).attributes},
      total: total
  end

  def show
    @subject = User.find(params[:id])
    render_data @subject
  end
end
