require 'rails_helper'

RSpec.describe 'Users', type: :request do
  include ActiveJob::TestHelper
  # 管理者権限はweb経由で変更できない
  it 'not allow the admin attribute to be edited via the web' do
    @user = FactoryBot.create(:user)
    log_in_as(@user)
    expect(@user.admin).to eq false
    expect do
      patch user_path(@user), params: { user: { password: @user.password,
                                                password_confirmation: @user.password_confirmation,
                                                admin: true } }
    end
    expect(@user.admin).to eq false
  end

  describe 'GET /index' do
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常に200レスポンスを返すこと
      it 'responds successfully and returns a 200 response' do
        log_in_as @user
        get users_path
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
        get users_path
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'get /show' do
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常に200レスポンスを返すこと
      it 'responds successfully and returns a 200 response' do
        log_in_as @user
        get user_path(@user)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end

    # 有効化されていないユーザーとして
    context 'as a non activated user' do
      before do
        @user = FactoryBot.create(:user, activated: false, activated_at: nil)
      end
      # # 302レスポンスを返し、トップページにリダイレクトすること
      it 'returns a 302 response' do
        log_in_as @user
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
        get users_path
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
        @user = FactoryBot.create(:user)
      end
      it 'returns a 302 response and redirect to user_path' do
        log_in_as @user
        get new_user_path
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to user_path(@user)
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 正常に200レスポンスを返すこと
      it 'responds successfully and returns a 200 response' do
        get new_user_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end
  end

  describe 'post /create' do
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end
      it 'returns a 302 response and redirect to user_path' do
        log_in_as @user
        post users_path
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to user_path(@user)
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 新規登録し、ユーザーを有効化する
      it 'is valid with valid signup info and active the user' do
        aggregate_failures do
          expect do
            post users_path, params: { user: { name: 'ExampleUser',
                                               email: 'user@example.com',
                                               seriousness: '軽症',
                                               password: 'password',
                                               password_confirmation: 'password' } }
          end.to change(User, :count).by(1)
          expect(response).to redirect_to top_path
          user = controller.instance_variable_get(:@user)
          # user = assigns(:user)
          expect(user.name).to eq 'ExampleUser'
          expect(user.email).to eq 'user@example.com'
          # 有効化していないとログインできない
          post login_path, params: { session: { email: user.email,
                                                password: user.password } }
          expect(session[:user_id]).to be_falsey
          # 有効化トークンが無効でメールアドレスが正しくてもログインできない
          get edit_account_activation_path('invalid token', email: user.email)
          expect(session[:user_id]).to be_falsey
          # トークンは正しいがメールアドレスが無効だとログインできない
          get edit_account_activation_path(user.activation_token, email: 'wrong')
          expect(session[:user_id]).to be_falsey
          # トークンが正しくメールアドレスが有効だとログインできる
          get edit_account_activation_path(user.activation_token, email: user.email)
          expect(session[:user_id]).to eq user.id
        end
      end
    end
  end

  describe 'get /edit' do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
    end
    # currnet_userは自らのプロフィール編集画面を表示できること
    it 'responds successfully and returns a 200 response' do
      log_in_as(@user)
      get edit_user_path(@user)
      aggregate_failures do
        expect(response).to be_successful
        expect(response).to have_http_status '200'
      end
    end
    # currnet_userは自分以外のプロフィール編集画面を表示できないこと
    it 'returns a 302 response and redirect to user_path' do
      log_in_as(@other_user)
      get edit_user_path(@user)
      aggregate_failures do
        expect(response).to have_http_status '302'
        expect(response).to redirect_to user_path(@other_user)
      end
    end
  end

  describe 'post /update' do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
    end
    context 'as an authenticated user' do
      # currnet_userは自分以外のプロフィール編集ができないこと
      it 'returns a 302 response and redirect to user_path' do
        log_in_as(@other_user)
        patch user_path(@user)
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to user_path(@other_user)
        end
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        patch user_path(@user)
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe '/login' do
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end
      # ログイン済みのユーザーはログインできないこと
      context 'get /login' do
        it 'returns a 302 response and redirect to user_path' do
          log_in_as @user
          get login_path
          aggregate_failures do
            expect(response).to have_http_status '302'
            expect(response).to redirect_to user_path(@user)
          end
        end
      end
      context 'post /login' do
        it 'returns a 302 response and redirect to user_path' do
          log_in_as @user
          post login_path
          aggregate_failures do
            expect(response).to have_http_status '302'
            expect(response).to redirect_to user_path(@user)
          end
        end
      end

    # パスワードを忘れた場合
    context 'user forgets the password' do
      # パスワードを再設定する
      it 'user updates the password' do
        user = create(:user)
        aggregate_failures do
          # パスワードが一致しない場合
          user.create_reset_digest
          get edit_password_reset_path(user.reset_token, email: user.email)
          patch password_reset_path(user.reset_token),
          params: { email: user.email,
            user: { password: 'fooobbar',
              password_confirmation: 'hdjfjsffjks' } }
              expect(response).to render_template(:edit)
              # パスワードが正しく入力された場合
              get edit_password_reset_path(user.reset_token, email: user.email)
              patch password_reset_path(user.reset_token),
              params: { email: user.email,
                user: { password: 'password',
                  password_confirmation: 'password' } }
                  expect(response).to redirect_to user_path(user)
                  expect(session[:user_id]).to eq user.id
                end
              end
            end
          end

    context '/logout' do
      before do
        @user = FactoryBot.create(:user)
      end
      # ログイン中のみログアウトすること
      it 'logs followed by logout' do
        log_in_as(@user)
        expect(session[:user_id]).to eq @user.id

        # ログアウトする
        delete logout_path
        expect(response).to redirect_to login_path
        expect(session[:user_id]).to be_falsey

        # 2番目のウィンドウでログアウトする
        delete logout_path
        expect(response).to redirect_to login_path
        expect(session[:user_id]).to be_falsy
      end
    end
  end

  describe 'delete /destroy' do
    before do
      @user = create(:user)
      @other_user = create(:user)
    end
    # 管理者の場合
    context 'as a admin' do
      it 'delete a user and redirect_to top_path' do
        @admin = create(:user, admin: true)
        log_in_as(@admin)
        expect do
          delete user_path(@user)
        end.to change(User, :count).by(-1)
        expect(response).to redirect_to users_path
      end
    end
    # 管理者ではない場合
    context 'as a non-admin' do
      it 'not delete a user and redirect_to top_path' do
        log_in_as(@user)
        expect do
          delete user_path(@user)
        end.to change(User, :count).by(0)
        expect(response).to redirect_to top_path
      end
    end
    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      it 'returns a 302 response and redirect to login_path' do
        delete user_path(@user)
        aggregate_failures do
          expect(response).to have_http_status '302'
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'get /follow' do
    before do
      @user = FactoryBot.create(:user)
    end
    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      # 正常に200レスポンスを返すこと
      context 'following_user_path' do
        it 'responds successfully and returns a 200 response' do
          log_in_as(@user)
          get following_user_path(@user)
          aggregate_failures do
            expect(response).to be_successful
            expect(response).to have_http_status '200'
          end
        end
      end

      context 'followers_user_path' do
        it 'responds successfully and returns a 200 response' do
          log_in_as(@user)
          get followers_user_path(@user)
          aggregate_failures do
            expect(response).to be_successful
            expect(response).to have_http_status '200'
          end
        end
      end
    end

    # ゲストとして
    context 'as a guest' do
      # 302レスポンスを返し、ログインページにリダイレクトすること
      context 'following_user_path' do
        it 'returns a 302 response and redirect to login_path' do
          get following_user_path(@user)
          aggregate_failures do
            expect(response).to have_http_status '302'
            expect(response).to redirect_to login_path
          end
        end
      end
      context 'followers_user_path' do
        it 'returns a 302 response and redirect to login_path' do
          get followers_user_path(@user)
          aggregate_failures do
            expect(response).to have_http_status '302'
            expect(response).to redirect_to login_path
          end
        end
      end
    end
  end
end
