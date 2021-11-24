# メインのサンプルユーザーを1人作成する
# User.create!(name: 'しげゆき',
#              email: 'shigeuki@rails.org',
#              seriousness: '中等症',
#              password: 'password',
#              password_confirmation: 'password',
#              admin: true,
#              activated: true,
#              activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
# 49.times do |n|
#   name  = Faker::Name.name
#   email = "example#{n}@rail.org"
#   seriousness = '軽症'
#   password = 'password'
#   User.create!(name: name,
#                email: email,
#                seriousness: seriousness,
#                password: password,
#                password_confirmation: password,
#                activated: true,
#                activated_at: 20191008)
# end

# users = User.order(:created_at).take(50)
# 30.times do |n|
#   title = Faker::Lorem.word
#   content = Faker::Lorem.sentence
#   start_time = Time.zone.today + n - 1
#   users.each do |user|
#     user.posts.create!(title: title, content: content,
#                        start_time: start_time)
#   end
# end

# users = User.all
user = User.first
# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }

d = Date.new(2019, 9, 26)
t = DateTime.new(2019, 9, 26, 21, 0)
11.times do |n| # 20190926~2019106
  took_medicine_at = (d + n)&.strftime('%Y年%m月%d日')
  created_at = t + n
  user.medicines.create!(took_medicine_at: took_medicine_at,
                         created_at: created_at, updated_at: created_at)
end
# RDS本番環境でこの上下を同時にやると500エラーになるので別々に実行する
# rake db:seed RAILS_ENV=production
d = Date.new(2019, 10, 8)
t = DateTime.new(2019, 10, 8, 21, 0)
776.times do |n| # 20191008~20211121
  took_medicine_at = (d + n)&.strftime('%Y年%m月%d日')
  created_at = t + n
  user.medicines.create!(took_medicine_at: took_medicine_at,
                         created_at: created_at, updated_at: created_at)
end
