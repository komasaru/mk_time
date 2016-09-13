module MkTime
  class Argument
    def initialize(arg)
      @arg = arg
    end

    #=========================================================================
    # 引数取得
    #
    # * コマンドライン引数を取得して日時の妥当性チェックを行う
    # * コマンドライン引数無指定なら、現在日時とする。
    #
    # @return: utc (Time Object)
    #=========================================================================
    def get_utc
      (puts Const::MSG_ERR_1; return) unless @arg =~ /^\d{8}$|^\d{14,}$/
      year, month, day = @arg[ 0, 4].to_i, @arg[ 4, 2].to_i, @arg[ 6, 2].to_i
      hour, min,   sec = @arg[ 8, 2].to_i, @arg[10, 2].to_i, @arg[12, 2].to_i
      usec = @arg.split(//).size > 14 ? @arg[14..-1].to_i : 0
      (puts Const::MSG_ERR_2; return) unless Date.valid_date?(year, month, day)
      (puts Const::MSG_ERR_2; return) if hour > 23 || min > 59 || sec >= 60.0
      d = usec.to_s.split(//).size
      return Time.new(
        year, month, day, hour, min, sec + Rational(usec, 10 ** d), "+00:00"
      )
    end
  end
end
