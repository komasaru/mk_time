require 'spec_helper'

describe MkTime do
  it 'has a version number' do
    expect(MkTime::VERSION).not_to be nil
  end

  let(:c) { MkTime::Calc.new(Time.new(2016, 7, 26, 0, 0, 0, "+00:00")) }

  context "#new(2016-07-26 00:00:00 +00:00)" do
    context "object" do
      it { expect(c).to be_an_instance_of(MkTime::Calc) }
    end

    context ".utc" do
      it { expect(c.utc.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:00:00" }
    end

    context ".jst" do
      it { expect(c.jst.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 09:00:00" }
    end

    context ".jd" do
      it { expect(c.jd).to eq 2457595.5 }
    end

    context ".t" do
      it { expect(c.t).to be_within(1.0e-16).of(0.1656536618754278) }
    end

    context ".utc_tai" do
      it { expect(c.utc_tai).to eq -36 }
    end

    context ".leap_sec" do
      it { expect(c.leap_sec).to eq -36 }
    end

    context ".dut1" do
      it { expect(c.dut1).to eq -0.2 }
    end

    context ".ut1" do
      it { expect(c.ut1.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-25 23:59:59" }
    end

    context ".ut1 (usec)" do
      it { expect((c.ut1.usec / 1000.0).round).to eq 800 }
    end

    context ".tai" do
      it { expect(c.tai.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:00:36" }
    end

    context ".tai (usec)" do
      it { expect((c.tai.usec / 1000.0).round).to eq 000 }
    end

    context ".dt" do
      it { expect(c.dt).to eq 68.384 }
    end

    context ".tt" do
      it { expect(c.tt.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:01:08" }
    end

    context ".tt (usec)" do
      it { expect((c.tt.usec / 1000.0).round).to eq 184 }
    end

    context ".tcg" do
      it { expect(c.tcg.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:01:09" }
    end

    context ".tcg (usec)" do
      it { expect((c.tcg.usec / 1000.0).round).to eq 54 }
    end

    context ".tcb" do
      it { expect(c.tcb.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:01:27" }
    end

    context ".tcb (usec)" do
      it { expect((c.tcb.usec / 1000.0).round).to eq 543 }
    end

    context ".tdb" do
      it { expect(c.tdb.strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 00:01:08" }
    end

    context ".tdb (usec)" do
      it { expect((c.tdb.usec / 1000.0).round).to eq 184 }
    end
  end
end
