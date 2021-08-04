class AddIndexToMedicinesTookMedicineAt < ActiveRecord::Migration[6.0]
  def change
    add_index :medicines, :took_medicine_at, unique: true
  end
end
