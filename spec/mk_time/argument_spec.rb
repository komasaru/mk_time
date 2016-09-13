require "spec_helper"
require "date"

describe MkTime::Argument do
  context "#self.new(\"20160723125959\")" do
    let(:a) { MkTime::Argument.new("20160723125959") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkTime::Argument) }
    end

    context ".get_utc" do
      subject { a.get_utc}
      it do
        expect(subject).to eq Time.new(2016, 7, 23, 12, 59, 59, "+00:00")
      end
    end
  end

  context "#self.new(\"20160723125959123\")" do
    let(:a) { MkTime::Argument.new("20160723125959123") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkTime::Argument) }
    end

    context ".get_utc" do
      subject { a.get_utc}
      it do
        expect(subject).to eq Time.new(2016, 7, 23, 12, 59, 59 + Rational(123, 1000), "+00:00")
      end
    end
  end

  context "#date-time digit is wrong" do
    let(:a) { MkTime::Argument.new("201607239") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkTime::Argument) }
    end

    context ".get_utc" do
      subject { a.get_utc }
      it { expect(subject).to be_nil }
    end
  end

  context "#invalid date-time" do
    let(:a) { MkTime::Argument.new("20160732") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkTime::Argument) }
    end

    context ".get_utc" do
      subject { a.get_utc }
      it { expect(subject).to be_nil }
    end
  end
end

