require "date"
require "mk_time/version"
require "mk_time/consts"
require "mk_time/argument"
require "mk_time/compute"
require "mk_time/calc"

module MkTime
  def self.new(arg)
    arg ||= Time.now.strftime("%Y%m%d%H%M%S")
    utc = MkTime::Argument.new(arg).get_utc
    return unless utc
    return MkTime::Calc.new(utc)
  end
end
