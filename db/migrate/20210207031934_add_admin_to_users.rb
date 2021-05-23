class AddAdminToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, default: false
    #デフォルトでは管理者にならないことを明示するためにdefault: falseを追加
  end
end
