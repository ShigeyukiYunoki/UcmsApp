module MedicinesHelper
  def time?(time)
    time&.strftime('%H%M').to_i
    # [*0..459, *2300..2359].include?(num)
  end

  def took_medicine
    @current_user = current_user
    gon.user = @current_user
    @now = Time.now.strftime('%H:%M')
    gon.now = @now
    @now_just_time = time?(Time.zone.now)
    gon.njt = @now_just_time

    return unless logged_in?

    @tookmedicinelast = current_user.medicines.where.not(took_medicine_at: nil).last
    if @tookmedicinelast
      @tooklastat = @tookmedicinelast.took_medicine_at
      gon.medicine = @tooklastat
    end

    @medicineslast = current_user.medicines.last
    gon.gft = time?(@gonnatake_just_time)
    if @medicineslast && current_user.medicines.where.not(gonna_take_medicine_at: nil).last
      @gonnatake = @medicineslast.gonna_take_medicine_at.strftime('%H:%M')
      gon.gonnatake = @gonnatake
      @gonnatake_just_time = @medicineslast.gonna_take_medicine_at
    end

    @no = current_user.medicines.where(took_medicine_at: nil).last
    gon.noexist = @no
    # return unless @no
    #
    #   @noid = @no.id
    #   gon.noid = @noid
  end

  def tookmedicines(user)
    @tookmedicines = user.medicines.where.not(took_medicine_at: nil).pluck('took_medicine_at')
  end

  def took_medicine_days_straight(user)
    return unless logged_in?

    @days = 0
    @max_days = 0
    # "took_medicine_at"を昇順で取得
    @tookmedicinedays = user.medicines.order(took_medicine_at: :asc).pluck('took_medicine_at')
    # 順番に２つごとに並べて日付を比較
    @tookmedicinedays.each_cons(2) do |f, s|
      # sがnilだと比較できずエラーになる
      if !s.nil?
        @fdt = DateTime.strptime(f, '%Y年%m月%d日')
        @sdt = DateTime.strptime(s, '%Y年%m月%d日')
        # ２つの日付を比較し連続なら＋１そうでないなら０
        if @fdt + 1 == @sdt
          @days += 1
          @max_days = @days if @max_days < @days
        else
          @days = 0
          # @max_days += 1
        end
      # gonna_take_medicine_atの値を持ち、took_medicine_atがnilのデータが最後に存在する場合
      # 最後はsがnilとなり比較できないので問答無用で＋１
      else
        @days += 1
        @max_days += 1
      end
    end
    # gonna_take_medicine_atの値を持ち、took_medicine_atがnilのデータが最後に存在しない場合
    # 最後のs自体存在せず比較できないのでこちらも問答無用で＋１
    @days += 1 unless @tookmedicinedays.last.nil?
    @max_days += 1 unless @tookmedicinedays.last.nil?
    # if @tookmedicinedays.count == 1
    #   @max_days = 1
    # end

    # if @tookmedicinedays.blank?
    #   @days = 0
    # end
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
