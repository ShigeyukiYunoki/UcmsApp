class AddIndexToUsersEmail < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :email, unique:true
    #Active Recordはデータベースのレベルでは一意性を保証していないので上記
  end
end
