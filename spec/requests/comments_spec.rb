require 'rails_helper'

RSpec.describe 'Comments', type: :request , focus: true do
  describe 'post /create' do
    let!(:headers) { { HTTP_REFEREE: 'http://www.example.com/' } }
    before do
      @user = create(:user, :with_posts)
      @other_user = create(:user, :with_posts)
      @post = @user.posts.first
    end
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      # 新たにコメントできる
      it 'create a new comment' do
        log_in_as(@user)
        aggregate_failures do
          expect do
            post post_comments_path(@post), params: { comment: { content: 'content',
                                                                 post_id: @post.id } }
          end.to change(Comment, :count).by(1)
          expect(response).to redirect_to headers[:HTTP_REFEREE]
          comment = Comment.last
          expect(comment).to be_truthy
        end
      end
      # contentがないとコメントできない
      it 'create a new comment' do
        log_in_as(@user)
        aggregate_failures do
          expect do
            post post_comments_path(@post), params: { comment: { content: '',
                                                                 post_id: @post.id } }
          end.to change(Comment, :count).by(0)
          expect(response).to redirect_to headers[:HTTP_REFEREE]
          comment = Comment.last
          expect(comment).to be_falsy
        end
      end
      # post_idがないとコメントできない
      it 'create a new comment' do
        log_in_as(@user)
        aggregate_failures do
          expect do
            post post_comments_path(@post), params: { comment: { content: 'content',
                                                                 post_id: nil } }
          end.to change(Comment, :count).by(0)
          expect(response).to redirect_to headers[:HTTP_REFEREE]
          comment = Comment.last
          expect(comment).to be_falsy
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        post post_comments_path(@post), params: { comment: { content: 'content',
                                                             post_id: @post.id } }
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end
end
