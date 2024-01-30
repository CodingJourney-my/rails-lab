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
