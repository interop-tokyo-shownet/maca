# frozen_string_literal: true

RSpec.describe Macaddress do
  context "#new" do
    it "create instance" do
      expect(Macaddress.new("00:00:00:00:00:00")).to be_instance_of(Macaddress)
    end

    it "raise error with invalid value" do
      expect {
        Macaddress.new("invalid address")
      }.to raise_error(Maca::InvalidAddressError)
    end
  end

  context "#valid?" do
    it "return true with valid value" do
      expect(Macaddress.valid?("00:00:00:00:00:00")).to be true
      expect(Macaddress.valid?("99:99:99:99:99:99")).to be true
      expect(Macaddress.valid?("aa:aa:aa:aa:aa:aa")).to be true
      expect(Macaddress.valid?("FF:FF:FF:FF:FF:FF")).to be true
    end

    it "return true when the delimiter is '-'" do
      expect(Macaddress.valid?("00-00-00-00-00-00")).to be true
    end

    it "return true when the delimiter is '.'" do
      expect(Macaddress.valid?("00.00.00.00.00.00")).to be true
    end

    it "return true when the delimiter is nothing" do
      expect(Macaddress.valid?("000000000000")).to be true
    end

    it "return true when the delimiter is '.' and step is 4" do
      expect(Macaddress.valid?("0000.0000.0000")).to be true
    end

    it "return true when the delimiter is '-' and step is 6" do
      expect(Macaddress.valid?("000000-000000")).to be true
    end

    it "return false with non-hexadecimal value" do
      expect(Macaddress.valid?("0g:00:00:00:00:00")).to be false
      expect(Macaddress.valid?("00:00:00:00:00:G0")).to be false
    end

    it "return false with strange delimiter position" do
      expect(Macaddress.valid?("000:000:000:000")).to be false
      expect(Macaddress.valid?("0.0.0.0.0.0.0.0.0.0.0.0")).to be false
    end

    it "return false with invalid value" do
      expect(Macaddress.valid?("invalid value")).to be false
    end
  end

  context "#to_s" do
    it "return mac address" do
      expect(Macaddress.new("00:00:00:00:00:00").to_s).to eq "00:00:00:00:00:00"
      expect(Macaddress.new("99:99:99:99:99:99").to_s).to eq "99:99:99:99:99:99"
      expect(Macaddress.new("FF:FF:FF:FF:FF:FF").to_s).to eq "FF:FF:FF:FF:FF:FF"
    end

    it "return value with lowercase letters replaced by uppercase letters" do
      expect(Macaddress.new("aa:aa:aa:aa:aa:aa").to_s).to eq "AA:AA:AA:AA:AA:AA"
    end

    it "return value with the delimiter replaced from '-' to ':'" do
      expect(Macaddress.new("00-00-00-00-00-00").to_s).to eq "00:00:00:00:00:00"
    end

    it "return value with the delimiter replaced from '.' to ':'" do
      expect(Macaddress.new("00.00.00.00.00.00").to_s).to eq "00:00:00:00:00:00"
    end

    it "return value with the delimiter ':' when delimiter is nothing " do
      expect(Macaddress.new("000000000000").to_s).to eq "00:00:00:00:00:00"
    end

    it "return value with the delimiter ':' when delimiter is '.' and step is 4" do
      expect(Macaddress.new("0000.0000.0000").to_s).to eq "00:00:00:00:00:00"
    end

    it "return value with the delimiter ':' when delimiter is '-' and step is 6" do
      expect(Macaddress.new("000000-000000").to_s).to eq "00:00:00:00:00:00"
    end
  end

  context "#format" do
    it "return value with the delimiter replaced from ':' to nothing" do
      expect(Macaddress.new("00:00:00:00:00:00").format(delimiter: '')).to eq "000000000000"
    end

    it "return value with the delimiter replaced from ':' to '-'" do
      expect(Macaddress.new("00:00:00:00:00:00").format(delimiter: '-')).to eq "00-00-00-00-00-00"
    end

    it "return value with the delimiter replaced from '-' to '.', step 4" do
      expect(Macaddress.new("00-00-00-00-00-00").format(delimiter: '.', step: 4)).to eq "0000.0000.0000"
    end

    it "return value with the delimiter replaced from ':' to '-', step 6" do
      expect(Macaddress.new("00:00:00:00:00:00").format(delimiter: '-', step: 6)).to eq "000000-000000"
    end

    it "step must be even and in range between 2 and 6" do
      expect{Macaddress.new("00:00:00:00:00:00").format(step: 1)}.to raise_error(RangeError)
      expect{Macaddress.new("00:00:00:00:00:00").format(step: 3)}.to raise_error(RangeError)
      expect{Macaddress.new("00:00:00:00:00:00").format(step: 5)}.to raise_error(RangeError)
      expect{Macaddress.new("00:00:00:00:00:00").format(step: 7)}.to raise_error(RangeError)
    end

  end

  context "#==" do
    it "return true with same address" do
      expect(Macaddress.new("00:00:00:00:00:00") == Macaddress.new("00:00:00:00:00:00")).to be true
    end

    it "return false with different address" do
      expect(Macaddress.new("00:00:00:00:00:00") == Macaddress.new("00:00:00:00:00:01")).to be false
    end

    it "return true when comparing values with different lowercase / uppercase letters" do
      expect(Macaddress.new("aa:aa:aa:aa:aa:aa") == Macaddress.new("AA:AA:AA:AA:AA:AA")).to be true
    end

    it "return true with different delimiter" do
      expect(Macaddress.new("00-00-00-00-00-00") == Macaddress.new("00:00:00:00:00:00")).to be true
      expect(Macaddress.new("00.00.00.00.00.00") == Macaddress.new("00:00:00:00:00:00")).to be true
      expect(Macaddress.new("000000000000") == Macaddress.new("00:00:00:00:00:00")).to be true
      expect(Macaddress.new("0000.0000.0000") == Macaddress.new("00:00:00:00:00:00")).to be true
      expect(Macaddress.new("000000-000000") == Macaddress.new("00:00:00:00:00:00")).to be true
    end
  end
end
