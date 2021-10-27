require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  include ActiveJob::TestHelper

  describe 'GET /index' do
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      before do
        @user = create(:user)
        @other_user = create(:user)
      end
      # 正常に200レスポンスを返すこと
      it 'responds successfully and returns a 200 response' do
        log_in_as @user
        get "/posts/#{@user.id}/index?start_date=#{Time.zone.today.strftime('%Y-%m-%d')}&post_index=1"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
        get "/posts/#{@other_user.id}/index?start_date=#{Time.zone.today.strftime('%Y-%m-%d')}&post_index=1"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
        get "/posts/#{@user.id}/index?start_date=#{Time.zone.today.strftime('%Y-%m-%d')}&post_index=0"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
        get "/posts/#{@other_user.id}/index?start_date=#{Time.zone.today.strftime('%Y-%m-%d')}&post_index=0"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        get "/posts/1/index?start_date=#{Time.zone.today.strftime('%Y-%m-%d')}&post_index=1"
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
        get "/posts/1/index?start_date=#{Time.zone.today.strftime('%Y-%m-%d')}&post_index=0"
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'get /show' do
    before do
      @user = create(:user, :with_posts)
    end
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      # 正常に200レスポンスを返すこと
      it 'responds successfully and returns a 200 response' do
        log_in_as @user
        get post_path(@user.posts.first)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        get post_path(@user.posts.first)
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'get /new' do
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      before do
        @user = create(:user)
      end
      # 正常に200レスポンスを返すこと
      it 'responds successfully and returns a 200 response' do
        log_in_as @user
        get new_post_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        get new_post_path
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'post /create' do
    before do
      @user = create(:user)
      @post = create(:post)
    end
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      # 新たに投稿できる
      it 'create a new post' do
        log_in_as(@user)
        aggregate_failures do
          expect do
            post posts_path, params: { post: { title: @post.title,
                                               content: @post.content,
                                               start_time: @post.start_time } }
          end.to change(Post, :count).by(1)
          expect(response).to redirect_to top_path
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        post posts_path
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'get /edit' do
    before do
      @user = create(:user, :with_posts)
      @other_user = create(:user, :with_posts)
    end
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      # currnet_userは自らの投稿編集画面を表示できること
      it 'responds successfully and returns a 200 response' do
        log_in_as(@user)
        get edit_post_path(@user.posts.first)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
      # currnet_userは自分以外の投稿編集画面を表示できないこと
      it 'returns a 302 response and redirect to top_path' do
        log_in_as(@user)
        get edit_post_path(@other_user.posts.first)
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to top_path
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        get edit_post_path(@user.posts.first)
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'post /update' do
    before do
      @user = create(:user, :with_posts)
      @other_user = create(:user, :with_posts)
    end
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      # currnet_userは自分の投稿編集ができること
      it 'responds successfully and returns a 200 response' do
        log_in_as(@user)
        post = @user.posts.first
        expect do
          patch post_path(post), params: { post: { title: post.title,
                                                   content: post.content,
                                                   start_time: post.start_time } }
        end.to change(Post, :count).by(0)
        expect(response).to redirect_to top_path
      end
      # currnet_userは自分以外の投稿編集ができないこと
      it 'returns a 302 response and redirect to post_path' do
        log_in_as(@user)
        patch post_path(@other_user.posts.first)
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to top_path
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        patch post_path(@user.posts.first)
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'delete /destroy' do
    before do
      @user = create(:user, :with_posts)
      @post = @user.posts.first
    end
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      it 'delete a post and redirect_to top_path' do
        log_in_as(@user)
        expect do
          delete post_path(@post)
        end.to change(Post, :count).by(-1)
        expect(response).to redirect_to top_path
      end
      # 投稿が削除されるとそのいいね！も削除されること
      it 'delete a post and delete users likes' do
        @other_user = create(:user, :with_posts)
        @like = create(:like, user_id: @other_user.id, post_id: @post.id)

        log_in_as(@user)
        expect(@other_user.likes).to be_truthy
        expect do
          delete post_path(@post)
        end.to change(Post, :count).by(-1)
        expect(response).to redirect_to top_path
        expect(@other_user.likes).to be_empty
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        delete post_path(@post)
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end
end
