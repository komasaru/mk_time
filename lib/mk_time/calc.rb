module MkTime
  class Calc
    include Compute
    attr_reader :utc

    #=========================================================================
    # Initialize
    #
    # @param:  arg   (引数)
    # @return: <none>
    #=========================================================================
    def initialize(arg)
      @utc = arg
    end

    #=========================================================================
    # JST (日本標準時)
    #
    # @param:  <none>
    # @return: @js  (Time Object)
    #=========================================================================
    def jst
      @jst = utc2jst(@utc)
    rescue => e
      raise
    end

    #=========================================================================
    # JD (ユリウス日)
    #
    # @param:  <none>
    # @return: @jd  (days)
    #=========================================================================
    def jd
      @jd = gc2jd(@utc)
    rescue => e
      raise
    end

    #=========================================================================
    # T (ユリウス世紀数)
    #
    # @param:  <none>
    # @return: @t  (centurys)
    #=========================================================================
    def t
      @jd ||= gc2jd(@utc)
      @t = jd2t(@jd)
    rescue => e
      raise
    end

    #=========================================================================
    # UTC - TAI (協定世界時と国際原子時の差 = うるう秒の総和)
    #
    # @param:  <none>
    # @return: @utc_tai  (seconds)
    #=========================================================================
    def utc_tai
      @utc_tai = get_utc_tai(@utc)
    rescue => e
      raise
    end

    #=========================================================================
    # LEAP SECONDS (= 協定世界時と国際原子時の差)
    #
    # @param:  <none>
    # @return: @leap_sec  (seconds)
    #=========================================================================
    def leap_sec
      @utc_tai ||= get_utc_tai(@utc)
      @leap_sec = @utc_tai
    rescue => e
      raise
    end

    #=========================================================================
    # DUT1 (UT1(世界時1) と UTC(協定世界時)の差)
    #
    # @param:  <none>
    # @return: @dut1  (seconds)
    #=========================================================================
    def dut1
      @dut1 = get_dut1(@utc)
    rescue => e
      raise
    end

    #=========================================================================
    # deltaT (TT(地球時) と UT1(世界時1)の差)
    #
    # @param:  <none>
    # @return: @dt  (seconds)
    #=========================================================================
    def dt
      @utc_tai ||= get_utc_tai(@utc)
      @dut1    ||= get_dut1(@utc)
      @dt = calc_dt(@utc)
    rescue => e
      raise
    end

    #=========================================================================
    # TAI (国際原子時)
    #
    # @param:  <none>
    # @return: @tai  (Time Object)
    #=========================================================================
    def tai
      @utc_tai ||= get_utc_tai(@utc)
      @tai = utc2tai(@utc)
    rescue => e
      raise
    end

    #=========================================================================
    # UT1 (世界時1)
    #
    # @param:  <none>
    # @return: @ut1  (Time Object)
    #=========================================================================
    def ut1
      @dut1 ||= get_dut1(@utc)
      @ut1 = utc2ut1(@utc)
    rescue => e
      raise
    end

    #=========================================================================
    # TT (地球時)
    #
    # @param:  <none>
    # @return: @tt  (Time Object)
    #=========================================================================
    def tt
      @utc_tai ||= get_utc_tai(@utc)
      @tai     ||= utc2tai(@utc)
      @tt = tai2tt(@tai)
    rescue => e
      raise
    end

    #=========================================================================
    # TCG (地球重心座標時)
    #
    # @param:  <none>
    # @return: @tcg  (Time Object)
    #=========================================================================
    def tcg
      @utc_tai ||= get_utc_tai(@utc)
      @tai     ||= utc2tai(@utc)
      @tt      ||= tai2tt(@tai)
      @jd      ||= gc2jd(@utc)
      @tcg = tt2tcg(@tt)
    rescue => e
      raise
    end

    #=========================================================================
    # TCB (太陽系重心座標時)
    #
    # @param:  <none>
    # @return: @tcb  (Time Object)
    #=========================================================================
    def tcb
      @utc_tai ||= get_utc_tai(@utc)
      @tai     ||= utc2tai(@utc)
      @tt      ||= tai2tt(@tai)
      @jd      ||= gc2jd(@utc)
      @tcb = tt2tcb(@tt)
    rescue => e
      raise
    end

    #=========================================================================
    # TDB (太陽系力学時)
    #
    # @param:  <none>
    # @return: @tdb  (Time Object)
    #=========================================================================
    def tdb
      @utc_tai ||= get_utc_tai(@utc)
      @tai     ||= utc2tai(@utc)
      @tt      ||= tai2tt(@tai)
      @jd      ||= gc2jd(@utc)
      @tcb     ||= tt2tcb(@tt)
      @tdb = tcb2tdb(@tcb)
    rescue => e
      raise
    end
  end
end

