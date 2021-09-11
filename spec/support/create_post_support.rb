# module CreatePostSupport
#   def create_post(post)
#     visit top_path
#     expect(current_path).to eq top_path
#     click_on '日記をかく'
#     fill_in 'タイトル', with: post.title
#     fill_in '投稿内容', with: post.content
#     attach_file 'post_image', "#{Rails.root}/spec/factories/kitten.jpg"
#     click_button '投稿'
#   end
# end
#
# RSpec.configure do |config|
#   config.include CreatePostSupport
# end
