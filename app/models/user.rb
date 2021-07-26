class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token # remember_tokenという仮想の属性を作成する

  has_many :posts, dependent: :destroy
  # 下記は上記にpostsメソッドとして存在する
  # def posts
  #   return Post.where(user_id: self.id)
  # end
  has_many :medicines, dependent: :destroy

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes, dependent: :destroy
  # 常にDBが大文字小文字を区別しているとは限らないので、DBに保存前に全てのemailを小文字に変換
  before_save :downcase_email # {email.downcase!} {self.email = email.downcase} 右式のselfは省略可
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGAX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGAX },
                    # メールアドレスの大文字小文字を区別しない一意性の検証
                    # uniqueness: {case_sensitive: false}
                    # 上記でemailを小文字に変換しているため、大文字小文字を区別しない一意性の検証は不要となる
                    uniqueness: true

  validates :seriousness, presence: true

  has_secure_password
  validates :password, length: { minimum: 8 }, presence: true, allow_nil: true

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # ユーザーオブジェクトのインスタンスが不要なので、このメソッドもUserモデルのクラスメソッドとして作成する
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    # update_attributeは特定の属性だけ更新するため、passwordの確認を回避できる
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def active
    update_columns(activated: true, activated_at: Time.zone.now)
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    # update_attribute(:reset_digest, User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired
    reset_sent_at < 2.hours.ago
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                    WHERE follower_id= :user_id"
    Post.where("user_id IN (#{following_ids}) OR user_id= :user_id", user_id: id)

    # うまく機能しない
    # part_of_feed = 'relationships.follower_id = :id or posts.user_id = :id'
    # Post.joins(user: :followers).where(part_of_feed, { id: id }).distinct
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
