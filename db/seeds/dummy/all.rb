dummy_path = Rails.root.join('db', 'seeds', 'dummy')

load(dummy_path.join('user.rb'))
load(dummy_path.join('category.rb'))
load(dummy_path.join('article.rb'))
