class MedicinesController < ApplicationController
  def new
    @medicine = current_user.medicines.build(medicine_params)
    @medicine.save(validate: false)
    # saveだと、on: :createでvalidatonがかかってしまうため、validatonが発生しないようにする
  end

  def create
    @lastmedicine = current_user.medicines.order(id: :desc).limit(1)
    @lastmedicine.create!(medicine_params)
  end

  private

  def medicine_params
    params.permit(:took_medicine_at, :gonna_take_medicine_at)
  end
end
