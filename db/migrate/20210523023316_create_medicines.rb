class CreateMedicines < ActiveRecord::Migration[6.0]
  def change
    create_table :medicines do |t|
      t.string :took_medicine_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
