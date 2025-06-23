# frozen_string_literal: true

module Maca
  class Macaddress
    REGEXP_MACADDRESS = /^([0-9A-Fa-f]{2}[:.-]?){5}([0-9A-Fa-f]{2})$/

    def initialize(addr)
      if Maca::Macaddress.valid?(addr)
        @macaddress = addr.downcase.gsub(/[-:.]/, '')
      else
        raise Maca::InvalidAddressError, "Invalid MAC Address #{addr}"
      end
    end

    def self.valid?(addr)
      REGEXP_MACADDRESS.match?(addr)
    end

    def to_s
      @macaddress.upcase.scan(/.{1,2}/).join(':')
    end

    def ==(other)
      self.to_s == other.to_s
    end
  end
end
