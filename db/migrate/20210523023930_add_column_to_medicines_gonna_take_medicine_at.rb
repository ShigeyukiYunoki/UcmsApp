class AddColumnToMedicinesGonnaTakeMedicineAt < ActiveRecord::Migration[6.0]
  def change
    add_column :medicines, :gonna_take_medicine_at, :datetime
  end
end
