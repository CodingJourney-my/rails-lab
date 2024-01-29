# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user_data = [
  {
    email: 'user@example.com',
    password: 'aaaaaaaa',
    profile: {
      name: 'テスト太郎',
      gender: 'male'
    }
  },
  {
    email: 'user1@example.com',
    password: 'aaaaaaaa',
    profile: {
      name: 'テスト太郎',
      gender: 'male'
    }
  },
  {
    email: 'user2@example.com',
    password: 'aaaaaaaa',
    profile: {
      name: 'テスト太郎',
      gender: 'male'
    }
  },
]


user_data.each do |args|
  profile_data = args.delete(:profile)

  email = args.delete(:email)
  user = User.find_or_initialize_by(email: email)
  user.assign_attributes(args)
  user.build_profile(profile_data)
  user.save!
  p user
end


article_data = {
  title: 'テストタイトル',
  content: 'テストコンテンツ',
}

user = User.first

article = user.articles.create(article_data)

p article

article.videos.find_or_create_by(
  uid: '12155835'
)

article.create_survey(name: 'テストアンケート', uid: "DQSIkWdsW0yxEjajBLZtrQAAAAAAAAAAAAO__V2ClJVURDJUOTRKMlM4OUlCQkxCN1dHR05HSDVDMi4u")
