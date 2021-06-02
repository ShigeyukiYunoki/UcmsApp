module MedicinesHelper

  def took_medicine
    @current_user = current_user
    gon.user = @currnet_user
    @now = Time.now.strftime("%H:%M")
    gon.now = @now

    if logged_in?
      @tookmedicinelast = current_user.medicines.where.not(took_medicine_at: nil).last
      if @tookmedicinelast
        @tooklastat = @tookmedicinelast.took_medicine_at
        gon.medicine = @tooklastat
      end

      @medicineslast = current_user.medicines.last
      if @medicineslast
        if current_user.medicines.where.not(gonna_take_medicine_at: nil).last
          @gonnatake = @medicineslast.gonna_take_medicine_at.strftime("%H:%M")
          gon.gonnatake = @gonnatake
        end
      end

      @no = current_user.medicines.where(took_medicine_at: nil).last
      gon.noexist = @no
      # if @no
      #   @noid = @no.id
      #   gon.noid = @noid
      # end
    end
  end

  def tookmedicines
   @tookmedicines = current_user.medicines.where.not(took_medicine_at: nil).pluck("took_medicine_at")
 end

  def took_medicine_days_straight
    if logged_in?
      @days = 0
      @tookmedicinedays = @current_user.medicines.order(took_medicine_at: :asc).pluck("took_medicine_at")

      @tookmedicinedays.each_cons(2) do |f,s|
        if !s.nil?
          @fdt = DateTime.strptime(f,'%Y年%m月%d日')
          @sdt = DateTime.strptime(s,'%Y年%m月%d日')
          if @fdt +1 == @sdt
            @days += 1
          else
            @days = 0
          end
        else
          @days += 1
        end
      end

      unless @tookmedicinedays.include?(nil)
        @days += 1
      end
  def tookmedicines
   @tookmedicines = current_user.medicines.where.not(took_medicine_at: nil).pluck("took_medicine_at")
 end

  def took_medicine_days_straight
    @days = 0
    @tookmedicinedays = @current_user.medicines.order(took_medicine_at: :asc).pluck("took_medicine_at")

    @tookmedicinedays.each_cons(2) do |f,s|
      if !s.nil?
        @fdt = DateTime.strptime(f,'%Y年%m月%d日')
        @sdt = DateTime.strptime(s,'%Y年%m月%d日')
        if @fdt +1 == @sdt
          @days += 1
        else
          @days = 0
        end
      else
        @days += 1
      end
    end

    unless @tookmedicinedays.include?(nil)
      @days += 1
    end
  end

  # def took_medicine_days_straight
  #   @days = 0
  #   @tookmedicinedays = @current_user.medicines.order(took_medicine_at: :asc)
  #   # took_medicine_atだけ取り出して並べてみる！
  #   @tookmedicinedays.each_with_index do |tookmedicineday, i|
  #     @tkm = tookmedicineday.took_medicine_at
  #     if @tkm
  #       @tkmdate = DateTime.strptime(@tkm,'%Y年%m月%d日')
  #       # @tkmdatetime = Time.parse(@tkmdate)
  #       if @tkmdate + 1 == @tkmdate.next
  #         @days += 1
  #       else
  #         @days = 0
  #       end
  #     end
  #   end
  # end

end
