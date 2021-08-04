class RemoveInReplyToFromPosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :in_reply_to, :inetger
  end
end
