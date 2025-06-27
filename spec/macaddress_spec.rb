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

  context "#to_fs" do
    it "return value with the delimiter replaced from ':' to nothing" do
      expect(Macaddress.new("00:00:00:00:00:00").to_fs(delimiter: '')).to eq "000000000000"
    end

    it "return value with the delimiter replaced from ':' to '-'" do
      expect(Macaddress.new("00:00:00:00:00:00").to_fs(delimiter: '-')).to eq "00-00-00-00-00-00"
    end

    it "return value with the delimiter replaced from '-' to '.', step 4" do
      expect(Macaddress.new("00-00-00-00-00-00").to_fs(delimiter: '.', step: 4)).to eq "0000.0000.0000"
    end

    it "return value with the delimiter replaced from ':' to '-', step 6" do
      expect(Macaddress.new("00:00:00:00:00:00").to_fs(delimiter: '-', step: 6)).to eq "000000-000000"
    end

    it "step must be even and in range between 2 and 6" do
      expect{Macaddress.new("00:00:00:00:00:00").to_fs(step: 1)}.to raise_error(RangeError)
      expect{Macaddress.new("00:00:00:00:00:00").to_fs(step: 3)}.to raise_error(RangeError)
      expect{Macaddress.new("00:00:00:00:00:00").to_fs(step: 5)}.to raise_error(RangeError)
      expect{Macaddress.new("00:00:00:00:00:00").to_fs(step: 7)}.to raise_error(RangeError)
    end
  end

  context "#to_i" do
    it "return decimal value of mac address" do
      expect(Macaddress.new("00:00:00:00:00:00").to_i).to eq 0
      expect(Macaddress.new("FF:FF:FF:FF:FF:FF").to_i).to eq 281474976710655
    end
  end

  context "#broadcast?" do
    it "return true if mac address is broadcast" do
      expect(Macaddress.new("ff:ff:ff:ff:ff:ff").broadcast?).to eq true
    end

    it "return false if mac address is multicast" do
      expect(Macaddress.new("01:00:00:00:00:00").broadcast?).to eq false
    end

    it "return false if mac address is unicast" do
      expect(Macaddress.new("00:00:00:00:00:00").broadcast?).to eq false
    end
  end

  context "#multicast?" do
    it "return true if mac address is broadcast" do
      expect(Macaddress.new("ff:ff:ff:ff:ff:ff").multicast?).to eq true
    end

    it "return true if mac address is multicast" do
      expect(Macaddress.new("01:00:00:00:00:00").multicast?).to eq true
      expect(Macaddress.new("01:00:5E:00:00:00").multicast?).to eq true
      expect(Macaddress.new("33:33:00:00:00:00").multicast?).to eq true
      expect(Macaddress.new("05:00:00:00:00:00").multicast?).to eq true
      expect(Macaddress.new("07:00:00:00:00:00").multicast?).to eq true
    end

    it "return false if mac address is unicast" do
      expect(Macaddress.new("00:00:00:00:00:00").multicast?).to eq false
    end
  end

  context "#unicast?" do
    it "return true if mac address is unicast" do
      expect(Macaddress.new("00:00:00:00:00:00").unicast?).to eq true
      expect(Macaddress.new("02:00:00:00:00:00").unicast?).to eq true
      expect(Macaddress.new("04:00:00:00:00:00").unicast?).to eq true
      expect(Macaddress.new("06:00:00:00:00:00").unicast?).to eq true
    end

    it "return false if mac address is multicast" do
      expect(Macaddress.new("01:00:00:00:00:00").unicast?).to eq false
    end

    it "return false if mac address is broadcast" do
      expect(Macaddress.new("ff:ff:ff:ff:ff:ff").unicast?).to eq false
    end
  end

  context "#locally_administered?" do
    it "return true if mac address is local administered" do
      expect(Macaddress.new("02:00:00:00:00:00").locally_administered?).to eq true
      expect(Macaddress.new("03:00:00:00:00:00").locally_administered?).to eq true
      expect(Macaddress.new("06:00:00:00:00:00").locally_administered?).to eq true
      expect(Macaddress.new("07:00:00:00:00:00").locally_administered?).to eq true
    end

    it "return false if mac address is broadcast" do
      expect(Macaddress.new("ff:ff:ff:ff:ff:ff").locally_administered?).to eq false
    end

    it "return false if mac address is not local administered" do
      expect(Macaddress.new("01:00:00:00:00:00").locally_administered?).to eq false
      expect(Macaddress.new("00:00:00:00:00:00").locally_administered?).to eq false
    end
  end

  context "#universally_administered?" do
    it "return true if mac address is universally administered" do
      expect(Macaddress.new("00:00:00:00:00:00").universally_administered?).to eq true
      expect(Macaddress.new("01:00:00:00:00:00").universally_administered?).to eq true
      expect(Macaddress.new("04:00:00:00:00:00").universally_administered?).to eq true
      expect(Macaddress.new("05:00:00:00:00:00").universally_administered?).to eq true
    end

    it "return false if mac address is local administered" do
      expect(Macaddress.new("02:00:00:00:00:00").universally_administered?).to eq false
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
