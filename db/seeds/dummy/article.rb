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
