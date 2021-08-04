
# def log_in(user)
#   allow_any_instance_of(ActionDispatch::Request)
#     .to receive(:session).and_return(user_id: user.id)
# end

# ログインする
def log_in_as(user)
  post login_path, params: { session: { email: user.email,
                                      password: user.password } }
end
