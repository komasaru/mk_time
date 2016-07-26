require "spec_helper"

describe MkTime::Compute do
  let(:c  ) { MkTime::Compute }
  let(:utc) { Time.new(2016, 7, 26, 0, 0, 0, "+00:00") }
  let(:jst) { Time.new(2016, 7, 26, 9, 0, 0, "+09:00") }

  context ".utc2jst" do
    subject { c.utc2jst(utc) }
    it { expect(subject).to eq jst }
  end

  context ".gc2jd" do
    subject { c.gc2jd(utc) }
    it { expect(subject).to eq 2457595.5 }
  end

  context ".jd2t" do
    subject { c.jd2t(2457595.5) }
    it { expect(subject).to be_within(1.0e-16).of(0.1656536618754278) }
  end

  context ".get_utc_tai" do
    subject { c.get_utc_tai(utc) }
    it { expect(subject).to eq -36 }
  end

  context ".get_dut1" do
    subject { c.get_dut1(utc) }
    it { expect(subject).to eq -0.2 }
  end

  context ".utc2ut1" do
    subject do
      c.instance_variable_set(:@dut1, -0.2)
      c.utc2ut1(utc)
    end
    it do
      expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-25 23:59:59"
      expect((subject.usec / 1000.0).round).to         eq  800
    end
  end

  context ".utc2tai" do
    subject do
      c.instance_variable_set(:@utc_tai, -36)
      c.utc2tai(utc)
    end
    it do
      expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:00:36"
      expect((subject.usec / 1000.0).round).to         eq  0
    end
  end

  context ".calc_dt" do
    subject do
      c.instance_variable_set(:@dut1,   -0.2)
      c.instance_variable_set(:@utc_tai, -36)
      c.calc_dt(utc)
    end
    it { expect(subject).to eq 68.384 }
  end

  context "#about calc_dt" do
    context ".calc_dt_before_m500" do
      subject { c.calc_dt_before_m500(-499 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(17174.615) }
    end

    context ".calc_dt_before_500(y)" do
      subject { c.calc_dt_before_500(499 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(10583.600) }
    end

    context ".  calc_dt_before_1600(y)" do
      subject { c.calc_dt_before_1600(1599 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(120.270) }
    end

    context ".  calc_dt_before_1700(y)" do
      subject { c.calc_dt_before_1700(1699 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(8.985) }
    end

    context ".  calc_dt_before_1800(y)" do
      subject { c.calc_dt_before_1800(1799 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(13.774) }
    end

    context ".  calc_dt_before_1860(y)" do
      subject { c.calc_dt_before_1860(1859 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(7.554) }
    end

    context ".  calc_dt_before_1900(y)" do
      subject { c.calc_dt_before_1900(1899 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(-2.763) }
    end

    context ".  calc_dt_before_1920(y)" do
      subject { c.calc_dt_before_1920(1919 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(21.178) }
    end

    context ".  calc_dt_before_1941(y)" do
      subject { c.calc_dt_before_1941(1940 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(24.755) }
    end

    context ".  calc_dt_before_1961(y)" do
      subject { c.calc_dt_before_1961(1960 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(33.531) }
    end

    context ".  calc_dt_before_1986(y)" do
      subject { c.calc_dt_before_1986(1985 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(54.848) }
    end

    context ".  calc_dt_before_2005(y)" do
      subject { c.calc_dt_before_2005(2004 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(64.710) }
    end

    context ".  calc_dt_before_2050(y)" do
      subject { c.calc_dt_before_2050(2049 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(92.964) }
    end

    context ".  calc_dt_until_2150(y)" do
      subject { c.calc_dt_until_2150(2149 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(328.392) }
    end

    context ".  calc_dt_after_2150(y)" do
      subject { c.calc_dt_after_2150(3000 + (12 - 0.5) / 12) }
      it { expect(subject).to be_within(0.001).of(4442.920) }
    end
  end

  context ".tai2tt" do
    let(:tai) { c.utc2tai(utc) }
    subject { c.tai2tt(tai) }
    it do
      expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:01:08"
      expect((subject.usec / 1000.0).round).to         eq  184
    end
  end

  context ".tt2tcg" do
    let(:tai) { c.utc2tai(utc) }
    let(:tt ) { c.tai2tt(tai)  }
    subject do
      c.instance_variable_set(:@jd, 2457595.5)
      c.tt2tcg(tt)
    end
    it do
      expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:01:09"
      expect((subject.usec / 1000.0).round).to         eq  54
    end
  end

  context ".tt2tcb" do
    let(:tai) { c.utc2tai(utc) }
    let(:tt ) { c.tai2tt(tai)  }
    subject do
      c.instance_variable_set(:@jd, 2457595.5)
      c.tt2tcb(tt)
    end
    it do
      expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:01:27"
      expect((subject.usec / 1000.0).round).to         eq  543
    end
  end

  context ".tcb2tdb" do
    let(:tai) { c.utc2tai(utc) }
    let(:tt ) { c.tai2tt(tai)  }
    let(:tcb) { c.tt2tcb(tt)   }
    subject { c.tcb2tdb(tcb) }
    it do
      expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:01:08"
      expect((subject.usec / 1000.0).round).to         eq  184
    end
  end
end

