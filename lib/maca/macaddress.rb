# frozen_string_literal: true

module Maca
  class Macaddress
    DEFAULT_DELIMITER = ':'
    DEFAULT_STEP = 2
    DELIMITERS = ':.-'
    REGEXP_MACADDRESS = /^([0-9A-Fa-f]{2}[#{DELIMITERS}]?){5}([0-9A-Fa-f]{2})$/

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
      format
    end

    def format(delimiter: DEFAULT_DELIMITER, step: DEFAULT_STEP)
      raise RangeError, "step must be even, and between 2 and 6" unless (2..6).cover?(step) && step.even?

      @macaddress.upcase.scan(/.{1,#{step}}/).join(delimiter)
    end

    def to_i
      @macaddress.hex
    end

    def ==(other)
      self.to_s == other.to_s
    end
  end
end
