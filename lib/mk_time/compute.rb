module MkTime
  module Compute
    module_function

    #=========================================================================
    # UTC(協定世界時) -> JST(日本標準時)
    #
    # * JST = UTC + 09:00
    #
    # @param:  utc  (Time Object)
    # @return: jst  (Time Object)
    #=========================================================================
    def utc2jst(utc)
      jst = utc + Const::JST_OFFSET * 60 * 60
      return Time.new(
        jst.year, jst.month, jst.day,
        jst.hour, jst.min, jst.sec,
        sprintf("+%02d:00", Const::JST_OFFSET)
      )
    rescue => e
      raise
    end

    #=========================================================================
    # 年月日(グレゴリオ暦) -> JD(ユリウス日)
    #
    # * フリーゲルの公式を使用する
    #   JD = int(365.25 * year)
    #      + int(year / 400)
    #      - int(year / 100)
    #      + int(30.59 (month - 2))
    #      + day
    #      + 1721088
    # * 上記の int(x) は厳密には、 x を超えない最大の整数
    # * 「ユリウス日」でなく「準ユリウス日」を求めるなら、
    #   `+ 1721088` を `- 678912` とする。
    #
    # @param:  t   (Time Object)
    # @return: jd  (ユリウス日)
    #=========================================================================
    def gc2jd(t)
      year, month, day = t.year, t.month, t.day
      hour, min, sec   = t.hour, t.min, t.sec

      begin
        # 1月,2月は前年の13月,14月とする
        if month < 3
          year  -= 1
          month += 12
        end
        # 日付(整数)部分計算
        jd  = (365.25 * year).floor \
            + (year / 400.0).floor \
            - (year / 100.0).floor \
            + (30.59 * (month - 2)).floor \
            + day \
            + 1721088.5
        # 時間(小数)部分計算
        t = (sec / 3600.0 + min / 60.0 + hour) / 24.0
        return jd + t
      rescue => e
        raise
      end
    end

    #=========================================================================
    # JD(ユリウス日) -> T(ユリウス世紀数)
    #
    # * t = (JD - 2451545) / 36525.0
    #
    # @param:  jd  (ユリウス日)
    # @return: t   (ユリウス世紀数)
    #=========================================================================
    def jd2t(jd)
      return (jd - Const::J2000) / (Const::JY * 100)
    rescue => e
      raise
    end

    #=========================================================================
    # UTC(協定世界時) - TAI(国際原子時) (= うるう秒総和) の取得
    #
    # * Ref: http://jjy.nict.go.jp/QandA/data/leapsec.html
    #
    # @param:  utc      (Time Object)
    # @return: utc_tai  (sec)
    #=========================================================================
    def get_utc_tai(utc)
      utc_tai = 0
      target = utc.strftime("%Y%m%d")

      begin
        Const::LEAP_SECS.reverse.each do |date, sec|
          if date <= target
            utc_tai = sec
            break
          end
        end
        return utc_tai
      rescue => e
        raise
      end
    end

    #=========================================================================
    # DUT1 (= UT1(世界時1) - UTC(協定世界時)) の取得
    #
    # * Ref: http://jjy.nict.go.jp/QandA/data/dut1.html
    #
    # @param:  utc   (Time Object)
    # @return: dut1  (sec)
    #=========================================================================
    def get_dut1(utc)
      dut1 = 0
      target = utc.strftime("%Y%m%d")

      begin
        Const::DUT1S.reverse.each do |date, sec|
          if date <= target
            dut1 = sec
            break
          end
        end
        return dut1
      rescue => e
        raise
      end
    end

    #=========================================================================
    # UTC(協定世界時) -> UT1(世界時1)
    #
    # * UT1 = UTC + DUT1
    #
    # @param:  utc  (Time Object)
    # @return: ut1  (Time Object)
    #=========================================================================
    def utc2ut1(utc)
      return utc + Rational(@dut1)
    rescue => e
      raise
    end

    #=========================================================================
    # UTC(協定世界時) -> TAI(国際原子時)
    #
    # * TAI = UTC - UTC_TAI
    #
    # @param:  utc  (Time Object)
    # @return: tai  (Time Object)
    #=========================================================================
    def utc2tai(utc)
      return utc - @utc_tai
    rescue => e
      raise
    end

    #=========================================================================
    # ΔT の計算
    #
    # * うるう秒調整が明確な場合は、うるう秒総和を使用した計算
    # * そうでない場合は、NASA の計算式による計算
    #
    # @param:  utc  (Time Object)
    # @return: dt   (sec)
    #=========================================================================
    def calc_dt(utc)
      return Rational(Const::TT_TAI, 1000) - @utc_tai - @dut1 unless @utc_tai == 0
      y = utc.year + (utc.month - 0.5) / 12
      case
      when                     utc.year <  -500; dt = calc_dt_before_m500(y)
      when -500 <= utc.year && utc.year <   500; dt = calc_dt_before_500(y)
      when  500 <= utc.year && utc.year <  1600; dt = calc_dt_before_1600(y)
      when 1600 <= utc.year && utc.year <  1700; dt = calc_dt_before_1700(y)
      when 1700 <= utc.year && utc.year <  1800; dt = calc_dt_before_1800(y)
      when 1800 <= utc.year && utc.year <  1860; dt = calc_dt_before_1860(y)
      when 1860 <= utc.year && utc.year <  1900; dt = calc_dt_before_1900(y)
      when 1900 <= utc.year && utc.year <  1920; dt = calc_dt_before_1920(y)
      when 1920 <= utc.year && utc.year <  1941; dt = calc_dt_before_1941(y)
      when 1941 <= utc.year && utc.year <  1961; dt = calc_dt_before_1961(y)
      when 1961 <= utc.year && utc.year <  1986; dt = calc_dt_before_1986(y)
      when 1986 <= utc.year && utc.year <  2005; dt = calc_dt_before_2005(y)
      when 2005 <= utc.year && utc.year <  2050; dt = calc_dt_before_2050(y)
      when 2050 <= utc.year && utc.year <= 2150; dt = calc_dt_until_2150(y)
      when 2150 <  utc.year                    ; dt = calc_dt_after_2150(y)
      end
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (year < -500)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_m500(y)
      t = (y - 1820) / 100.0
      dt = -20 + 32 * t ** 2
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (-500 <= year && year < 500)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_500(y)
      t = y / 100.0
      dt  = 10583.6
           (-1014.41        + \
           (   33.78311     + \
           (   -5.952053    + \
           (   -0.1798452   + \
           (    0.022174192 + \
           (    0.0090316521) \
           * t) * t) * t) * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (500 <= year && year < 1600)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_1600(y)
      t = (y - 1000) / 100.0
      dt  = 1574.2         + \
           (-556.01        + \
           (  71.23472     + \
           (   0.319781    + \
           (  -0.8503463   + \
           (  -0.005050998 + \
           (   0.0083572073) \
           * t) * t) * t) * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (1600 <= year && year < 1700)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_1700(y)
      t = y - 1600
      dt  = 120           + \
           ( -0.9808      + \
           ( -0.01532     + \
           (  1.0 / 7129.0) \
           * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (1700 <= year && year < 1800)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_1800(y)
      t = y - 1700
      dt  =  8.83           + \
           ( 0.1603         + \
           (-0.0059285      + \
           ( 0.00013336     + \
           (-1.0 / 1174000.0) \
           * t) * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (1800 <= year && year < 1860)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_1860(y)
      t = y - 1800
      dt  = 13.72          + \
           (-0.332447      + \
           ( 0.0068612     + \
           ( 0.0041116     + \
           (-0.00037436    + \
           ( 0.0000121272  + \
           (-0.0000001699  + \
           ( 0.000000000875) \
           * t) * t) * t) * t) * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (1860 <= year && year < 1900)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_1900(y)
      t = y - 1860
      dt  =  7.62          + \
           ( 0.5737        + \
           (-0.251754      + \
           ( 0.01680668    + \
           (-0.0004473624  + \
           ( 1.0 / 233174.0) \
           * t) * t) * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (1900 <= year && year < 1920)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_1920(y)
      t = y - 1900
      dt  = -2.79      + \
           ( 1.494119  + \
           (-0.0598939 + \
           ( 0.0061966 + \
           (-0.000197  ) \
           * t) * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (1920 <= year && year < 1941)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_1941(y)
      t = y - 1920
      dt  = 21.20     + \
           ( 0.84493  + \
           (-0.076100 + \
           ( 0.0020936) \
           * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (1941 <= year && year < 1961)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_1961(y)
      t = y - 1950
      dt  = 29.07      + \
           ( 0.407     + \
           (-1 / 233.0 + \
           ( 1 / 2547.0) \
           * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (1961 <= year && year < 1986)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_1986(y)
      t = y - 1975
      dt = 45.45      + \
          ( 1.067     + \
          (-1 / 260.0 + \
          (-1 / 718.0)  \
          * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (1986 <= year && year < 2005)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_2005(y)
      t = y - 2000
      dt  = 63.86         + \
           ( 0.3345       + \
           (-0.060374     + \
           ( 0.0017275    + \
           ( 0.000651814  + \
           ( 0.00002373599) \
           * t) * t) * t) * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (2005 <= year && year < 2050)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_before_2050(y)
      t = y - 2000
      dt  = 62.92    + \
           ( 0.32217 + \
           ( 0.005589) \
           * t) * t
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (2050 <= year && year <= 2150)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_until_2150(y)
      dt  = -20 \
          + 32 * ((y - 1820) / 100.0) ** 2
          - 0.5628 * (2150 - y)
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (2150 < year)
    #
    # @param:  y   (Year coefficient for deltaT calculation)
    # @return: dt  (sec)
    #=========================================================================
    def calc_dt_after_2150(y)
      t = (y - 1820) / 100.0
      dt  = -20 + 32 * t ** 2
      return dt
    rescue => e
      raise
    end

    #=========================================================================
    # TT(地球時)
    #
    # * TT = TAI + TT_TAI
    #      = UT1 + ΔT
    #=========================================================================
    def tai2tt(tai)
      return tai + Rational(Const::TT_TAI, 1000)
    rescue => e
      raise
    end

    #=========================================================================
    # TCG(地球重心座標時)
    #
    # * TCG = TT + L_G * (JD - T_0) * 86,400
    #   （JD: ユリウス日,
    #     L_G = 6.969290134 * 10^(-10), T_0 = 2,443,144.5003725）
    #
    # @param:  tt   (Time Object)
    # @return: tcg  (Time Object)
    #=========================================================================
    def tt2tcg(tt)
      return tt + Const::L_G * (@jd - Const::T_0) * 86400
    rescue => e
      raise
    end

    #=========================================================================
    # TCB(太陽系重心座標時)
    #
    # * TCB = TT + L_B * (JD - T_0) * 86400
    #
    # @param:  tt   (Time Object)
    # @return: tcb  (Time Object)
    #=========================================================================
    def tt2tcb(tt)
      return tt + Const::L_B * (@jd - Const::T_0) * 86400
    rescue => e
      raise
    end

    #=========================================================================
    # TCB(太陽系重心座標時) -> TDB(太陽系力学時)
    #
    # * TDB = TCB - L_B * (JD_TCB - T_0) * 86400 + TDB_0
    #
    # @param:  tcb  (Time Object)
    # @return: tdb  (Time Object)
    #=========================================================================
    def tcb2tdb(tcb)
      jd_tcb = gc2jd(tcb)
      return tcb - Const::L_B * (jd_tcb - Const::T_0) * 86400 + Const::TDB_0
    rescue => e
      raise
    end
  end
end

