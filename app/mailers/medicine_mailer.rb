# class MedicineMailer < ApplicationMailer
#   include UsersHelper
#   include MedicinesHelper
#
#   def take_medicine(user)
#     @user = user
#
#     mail to: user.email, subject: '服薬のお知らせ'
#   end
#
#   def medicine_mail
#     @current_user = current_user
#     return unless @gonnatake && Time.zone.now.strftime('%H:%M') == @gonnatake
#
#     MedicineMailer.take_medicine(@current_user).deliver_now
#   end
# end
