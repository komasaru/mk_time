module MkTime
  class Calc
    attr_reader :utc, :jst, :jd, :t, :utc_tai, :leap_sec, :dut1,
                :ut1, :tai, :dt, :tt, :tcg, :tcb, :tdb
    include Compute
    alias leap_sec utc_tai

    def initialize(arg)
      @utc      = arg
      @jst      = utc2jst(@utc)
      @jd       = gc2jd(@utc)
      @t        = jd2t(@jd)
      @utc_tai  = get_utc_tai(@utc)
      @dut1     = get_dut1(@utc)
      @ut1      = utc2ut1(@utc)
      @tai      = utc2tai(@utc)
      @dt       = calc_dt(@utc)
      @tt       = tai2tt(@tai)
      @tcg      = tt2tcg(@tt)
      @tcb      = tt2tcb(@tt)
      @tdb      = tcb2tdb(@tcb)
    end
  end
end

