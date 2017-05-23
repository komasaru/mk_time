module MkTime
  module Const
    MSG_ERR_1  = "[ERROR] Format: YYYYMMDD or YYYYMMDDHHMMSS"
    MSG_ERR_2  = "[ERROR] Invalid date-time!"
    JST_OFFSET = 9                # JST offset from UTC
    J2000      = 2451545          # Julian Day of 2000-01-01 12:00:00
    JY         = 365.25           # 1 Julian Year
    TT_TAI     = 32184            # (TT - TAI) * 1000 (計算時の誤差抑制のため 1000 倍している)
    L_G        = 6.969290134e-10  # for TCG
    L_B        = 1.550519768e-8   # for TCG, TDB
    T_0        = 2443144.5003725  # for TCG, TDB, TCB
    TDB_0      = -6.55e-5         # for TDB
    LEAP_SECS  = [
                   ["19720101", -10],
                   ["19720701", -11],
                   ["19730101", -12],
                   ["19740101", -13],
                   ["19750101", -14],
                   ["19760101", -15],
                   ["19770101", -16],
                   ["19780101", -17],
                   ["19790101", -18],
                   ["19800101", -19],
                   ["19810701", -20],
                   ["19820701", -21],
                   ["19830701", -22],
                   ["19850701", -23],
                   ["19880101", -24],
                   ["19900101", -25],
                   ["19910101", -26],
                   ["19920701", -27],
                   ["19930701", -28],
                   ["19940701", -29],
                   ["19960101", -30],
                   ["19970701", -31],
                   ["19990101", -32],
                   ["20060101", -33],
                   ["20090101", -34],
                   ["20120701", -35],
                   ["20150701", -36],
                   ["20170101", -37],
                   ["20190101",   0]  # (<= Provisional end-point)
                 ].freeze  # Leap Second's adjustment
    DUT1S      = [
                   ["19880317",  0.2],
                   ["19880512",  0.1],
                   ["19880825",  0.0],
                   ["19881110", -0.1],
                   ["19890119", -0.2],
                   ["19890406", -0.3],
                   ["19890608", -0.4],
                   ["19890921", -0.5],
                   ["19891116", -0.6],
                   ["19900101",  0.3],
                   ["19900301",  0.2],
                   ["19900412",  0.1],
                   ["19900510",  0.0],
                   ["19900726", -0.1],
                   ["19900920", -0.2],
                   ["19901101", -0.3],
                   ["19910101",  0.6],
                   ["19910207",  0.5],
                   ["19910321",  0.4],
                   ["19910425",  0.3],
                   ["19910620",  0.2],
                   ["19910822",  0.1],
                   ["19911017",  0.0],
                   ["19911121", -0.1],
                   ["19920123", -0.2],
                   ["19920227", -0.3],
                   ["19920402", -0.4],
                   ["19920507", -0.5],
                   ["19920701",  0.4],
                   ["19920903",  0.3],
                   ["19921022",  0.2],
                   ["19921126",  0.1],
                   ["19930114",  0.0],
                   ["19930218", -0.1],
                   ["19930401", -0.2],
                   ["19930506", -0.3],
                   ["19930701",  0.6],
                   ["19930819",  0.5],
                   ["19931007",  0.4],
                   ["19931118",  0.3],
                   ["19931230",  0.2],
                   ["19940210",  0.1],
                   ["19940317",  0.0],
                   ["19940421", -0.1],
                   ["19940609", -0.2],
                   ["19940701",  0.8],
                   ["19940811",  0.7],
                   ["19941006",  0.6],
                   ["19941117",  0.5],
                   ["19941222",  0.4],
                   ["19950223",  0.3],
                   ["19950316",  0.2],
                   ["19950413",  0.1],
                   ["19950525",  0.0],
                   ["19950713", -0.1],
                   ["19950907", -0.2],
                   ["19951026", -0.3],
                   ["19951130", -0.4],
                   ["19960101",  0.5],
                   ["19960222",  0.4],
                   ["19960411",  0.3],
                   ["19960516",  0.2],
                   ["19960808",  0.1],
                   ["19961003",  0.0],
                   ["19961205", -0.1],
                   ["19970206", -0.2],
                   ["19970320", -0.3],
                   ["19970508", -0.4],
                   ["19970626", -0.5],
                   ["19970701",  0.5],
                   ["19970918",  0.4],
                   ["19971030",  0.3],
                   ["19971218",  0.2],
                   ["19980219",  0.1],
                   ["19980326",  0.0],
                   ["19980507", -0.1],
                   ["19980813", -0.2],
                   ["19981126", -0.3],
                   ["19990101",  0.7],
                   ["19990304",  0.6],
                   ["19990527",  0.5],
                   ["19991014",  0.4],
                   ["20000106",  0.3],
                   ["20000413",  0.2],
                   ["20001019",  0.1],
                   ["20010301",  0.0],
                   ["20011004", -0.1],
                   ["20020214", -0.2],
                   ["20021024", -0.3],
                   ["20030403", -0.4],
                   ["20040429", -0.5],
                   ["20050317", -0.6],
                   ["20060101",  0.3],
                   ["20060427",  0.2],
                   ["20060928",  0.1],
                   ["20061222",  0.0],
                   ["20070315", -0.1],
                   ["20070614", -0.2],
                   ["20071129", -0.3],
                   ["20080313", -0.4],
                   ["20080807", -0.5],
                   ["20081120", -0.6],
                   ["20090101",  0.4],
                   ["20090312",  0.3],
                   ["20090611",  0.2],
                   ["20091112",  0.1],
                   ["20100311",  0.0],
                   ["20100603", -0.1],
                   ["20110106", -0.2],
                   ["20110512", -0.3],
                   ["20111104", -0.4],
                   ["20120209", -0.5],
                   ["20120510", -0.6],
                   ["20120701",  0.4],
                   ["20121025",  0.3],
                   ["20130131",  0.2],
                   ["20130411",  0.1],
                   ["20130822",  0.0],
                   ["20131121", -0.1],
                   ["20140220", -0.2],
                   ["20140508", -0.3],
                   ["20140925", -0.4],
                   ["20141225", -0.5],
                   ["20150319", -0.6],
                   ["20150528", -0.7],
                   ["20150701",  0.3],
                   ["20150917",  0.2],
                   ["20151126",  0.1],
                   ["20160131",  0.0],
                   ["20160324", -0.1],
                   ["20160519", -0.2],
                   ["20160901", -0.3],
                   ["20161117", -0.4],
                   ["20170101",  0.6],
                   ["20170126",  0.5],
                   ["20170330",  0.4],
                   ["20170629",  0.3],
                   ["20170929",  0.0]  # (<= Provisional end-point)
                 ].freeze  # DUT1 adjustment
  end
end
