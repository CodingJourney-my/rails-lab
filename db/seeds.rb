# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user_data = {
  name: 'テスト太郎',
  email: 'user@example.com',
  password: 'aaaaaaaa'
}

user_email = user_data.delete(:email)
user = User.find_or_initialize_by(email: user_email)
user.assign_attributes(user_data)
user.save!

p user

article_data = {
  title: 'テストタイトル',
  content: 'テストコンテンツ',
}

article = user.articles.create(article_data)

p article

article.videos.find_or_create_by(
  uid: '12155835'
)

article.create_survey(name: 'テストアンケート', uid: "DQSIkWdsW0yxEjajBLZtrQAAAAAAAAAAAAO__V2ClJVURDJUOTRKMlM4OUlCQkxCN1dHR05HSDVDMi4u")