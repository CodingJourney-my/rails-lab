class User::VideoViewsController < ApplicationController

  def show
    video_view = UserVideoView.find_by(user_id: @current_user.id, video_id: params[:id])
    render json: { last_play_time: video_view&.play_time }
  end

  def create
    # リクエストボディをパース
    data = JSON.parse(request.body.read)

    video_view = UserVideoView.find_or_initialize_by(user_id: @current_user.id, video_id: data['video_id'])
    video_view.assign_attributes(play_time: data['time'])

    if video_view.save!
      render json: { message: 'Video play time saved successfully.' }, status: :ok
    else
      render json: { message: 'Failed to save video play time.' }, status: :unprocessable_entity
    end
  end
end
