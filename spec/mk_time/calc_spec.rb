require "spec_helper"

describe MkTime::Calc do
  let(:c) { MkTime::Calc.new(Time.new(2016, 7, 27, 0, 0, 0, "+00:00")) }

  context "#new(2016-07-27 00:00:00 +00:00)" do
    context "object" do
      it { expect(c).to be_an_instance_of(MkTime::Calc) }
    end

    context "@utc" do
      it { expect(c.instance_variable_get(:@utc).strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-27 00:00:00" }
    end

    context "#methods" do
      let(:utc) { Time.new(2016, 7, 27, 0, 0, 0, "+00:00") }

      context ".jst" do
        subject do
          c.instance_variable_set(:@utc, utc)
          c.jst
        end
        it do
          expect(subject).to                        eq Time.new(2016, 7, 27, 9, 0, 0, "+09:00")
          expect(c.instance_variable_get(:@jst)).to eq Time.new(2016, 7, 27, 9, 0, 0, "+09:00")
        end
      end

      context ".jd" do
        subject { c.jd }
        it do
          expect(subject).to                       eq 2457596.5
          expect(c.instance_variable_get(:@jd)).to eq 2457596.5
        end
      end

      context ".t" do
        subject { c.t }
        it do
          expect(subject).to                      be_within(1.0e-17).of(0.16568104038329912)
          expect(c.instance_variable_get(:@t)).to be_within(1.0e-17).of(0.16568104038329912)
        end
      end

      context ".utc_tai" do
        subject { c.utc_tai }
        it do
          expect(subject).to                            eq -36
          expect(c.instance_variable_get(:@utc_tai)).to eq -36
        end
      end

      context ".leap_sec" do
        subject { c.leap_sec }
        it do
          expect(subject).to                             eq -36
          expect(c.instance_variable_get(:@leap_sec)).to eq -36
        end
      end

      context ".dut1" do
        subject { c.dut1 }
        it do
          expect(subject).to                         eq -0.2
          expect(c.instance_variable_get(:@dut1)).to eq -0.2
        end
      end

      context ".ut1" do
        subject { c.ut1 }
        it do
          expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to                        eq "2016-07-26 23:59:59"
          expect((subject.usec / 1000.0).round).to                                eq 800
          expect(c.instance_variable_get(:@ut1).strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-26 23:59:59"
          expect((c.instance_variable_get(:@ut1).usec / 1000.0).round).to         eq 800
        end
      end

      context ".tai" do
        subject { c.tai }
        it do
          expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to                        eq "2016-07-27 00:00:36"
          expect((subject.usec / 1000.0).round).to                                eq 0
          expect(c.instance_variable_get(:@tai).strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-27 00:00:36"
          expect((c.instance_variable_get(:@tai).usec / 1000.0).round).to         eq 0
        end
      end

      context ".dt" do
        subject { c.dt }
        it do
          expect(subject).to                       eq 68.384
          expect(c.instance_variable_get(:@dt)).to eq 68.384
        end
      end

      context ".tt" do
        subject { c.tt }
        it do
          expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to                       eq "2016-07-27 00:01:08"
          expect((subject.usec / 1000.0).round).to                               eq 184
          expect(c.instance_variable_get(:@tt).strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-27 00:01:08"
          expect((c.instance_variable_get(:@tt).usec / 1000.0).round).to         eq 184
        end
      end

      context ".tcg" do
        subject { c.tcg }
        it do
          expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to                        eq "2016-07-27 00:01:09"
          expect((subject.usec / 1000.0).round).to                                eq 54
          expect(c.instance_variable_get(:@tcg).strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-27 00:01:09"
          expect((c.instance_variable_get(:@tcg).usec / 1000.0).round).to         eq 54
        end
      end

      context "@tcb" do
        subject { c.tcb }
        it do
          expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to                        eq "2016-07-27 00:01:27"
          expect((subject.usec / 1000.0).round).to                                eq 545
          expect(c.instance_variable_get(:@tcb).strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-27 00:01:27"
          expect((c.instance_variable_get(:@tcb).usec / 1000.0).round).to         eq 545
        end
      end

      context "@tdb" do
        subject { c.tdb }
        it do
          expect(subject.strftime("%Y-%m-%d %H:%M:%S")).to                        eq "2016-07-27 00:01:08"
          expect((subject.usec / 1000.0).round).to                                eq 184
          expect(c.instance_variable_get(:@tdb).strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-07-27 00:01:08"
          expect((c.instance_variable_get(:@tdb).usec / 1000.0).round).to         eq 184
        end
      end
    end
  end
end

