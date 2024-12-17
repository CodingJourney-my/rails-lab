class Api::V1::UsersController < BaseController

  class_attribute :subject_class, :subject_serializer, :subject_detail_serializer, :subject_deserializer
  self.subject_class = User
  self.subject_serializer = User::ApiSerializer
  self.subject_detail_serializer = User::ApiSerializer
  # self.subject_deserializer = User::ApiDeserializer

  before_action do
    @subjects = subject_class.all
  end

  def index
    total = @subjects.count
    @subjects = @subjects.limit(current_limit).offset(current_offset)
    render_data @subjects.map{|x| subject_serializer.new(x).attributes},
      total: total
  end

  def show
    subject = @subjects.find(params[:id])
    render_data subject_detail_serializer.new(subject).attributes
  end
end
