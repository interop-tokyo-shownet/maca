# frozen_string_literal: true

require_relative "maca/version"
require_relative "maca/macaddress"

require_relative "macaddress"

module Maca
  class Error < StandardError; end
  class InvalidAddressError < ArgumentError; end
end
