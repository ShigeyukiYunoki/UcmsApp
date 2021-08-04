class ChangeIndexToMedicinesTookMedicineAt < ActiveRecord::Migration[6.0]
  def change
    remove_index :medicines, :took_medicine_at
    add_index :medicines, [:took_medicine_at,:user_id], unique: true
  end
end
