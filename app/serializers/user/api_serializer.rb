class User::ApiSerializer < ActiveModel::Serializer
  attributes :id
  attributes :email
end
