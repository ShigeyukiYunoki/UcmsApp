class Post < ApplicationRecord
  belongs_to :user
  # 下記は上記にuserメソッドとして存在する
  # def user
  #   return User.find_by(id: self.user_id)
  # end
  has_one_attached :image
  # default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true, length: { maximum: 300 }
  validates :start_time, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: 'はjpeg,gif,pngのみ対応しています' },
                    size: { less_than: 5.megabytes,
                            message: 'のサイズは５MBまでです' }
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments, source: :user

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
