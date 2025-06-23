# frozen_string_literal: true

class Macaddress
  VERSION = "0.1.0"

  class Error < StandardError; end
  class InvalidAddressError < ArgumentError; end

  REGEXP_MACADDRESS = /^([0-9A-Fa-f]{2}[:.-]){5}([0-9A-Fa-f]{2})$/

  def initialize(addr)
    if Macaddress.valid?(addr)
      @macaddress = addr
    else
      raise InvalidAddressError, "Invalid MAC Address #{addr}"
    end
  end

  def self.valid?(addr)
    REGEXP_MACADDRESS.match?(addr)
  end

  def to_s
    @macaddress
  end
end
