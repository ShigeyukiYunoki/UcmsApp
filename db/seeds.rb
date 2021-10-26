# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# メインのサンプルユーザーを1人作成する
User.create!(name: '柚木繁之',
             email: 'shigeuki@rails.org',
             seriousness: '中等症',
             password: 'password',
             password_confirmation: 'password',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
49.times do |n|
  name  = Faker::Name.name
  email = "#{Faker::Lorem.word}@rail.org"
  seriousness = '軽症'
  password = 'password'
  User.create!(name: name,
               email: email,
               seriousness: seriousness,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: 20191008)
end

users = User.order(:created_at).take(50)
30.times do |n|
  title = Faker::Lorem.word
  content = Faker::Lorem.sentence
  start_time = Time.zone.today + n - 1
  # start_time = Faker::Date.between(from: 6.months.ago, to: 6.months.from_now)
  users.each do |user|
    user.posts.create!(title: title, content: content,
                       start_time: start_time)
  end
end

users = User.all
user = User.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
