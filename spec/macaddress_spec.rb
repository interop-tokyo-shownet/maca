# frozen_string_literal: true

RSpec.describe Macaddress do
  it "has a version number" do
    expect(Macaddress::VERSION).not_to be nil
  end

  context "#new" do
    it "create instance" do
      expect(Macaddress.new("00:00:00:00:00:00")).to be_instance_of(Macaddress)
    end

    it "raise error with invalid value" do
      expect {
        Macaddress.new("invalid address")
      }.to raise_error(Macaddress::InvalidAddressError)
    end
  end

  context "#valid?" do
    it "return ture with valid value" do
      expect(Macaddress.valid?("00:00:00:00:00:00")).to be true
      expect(Macaddress.valid?("99:99:99:99:99:99")).to be true
      expect(Macaddress.valid?("aa:aa:aa:aa:aa:aa")).to be true
      expect(Macaddress.valid?("FF:FF:FF:FF:FF:FF")).to be true
    end

    it "return ture when the delimiter is '-'" do
      expect(Macaddress.valid?("00-00-00-00-00-00")).to be true
    end

    it "return ture when the delimiter is '.'" do
      expect(Macaddress.valid?("00.00.00.00.00.00")).to be true
    end

    it "return false with non-hexadecimal value" do
      expect(Macaddress.valid?("0g:00:00:00:00:00")).to be false
      expect(Macaddress.valid?("00:00:00:00:00:G0")).to be false
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
  end
end
