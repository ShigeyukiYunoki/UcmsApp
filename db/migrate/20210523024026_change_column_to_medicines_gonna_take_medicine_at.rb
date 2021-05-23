class ChangeColumnToMedicinesGonnaTakeMedicineAt < ActiveRecord::Migration[6.0]
  def change
    change_column :medicines, :gonna_take_medicine_at, :time
  end
end
