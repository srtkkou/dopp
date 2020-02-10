# frozen_string_literal: true

require 'nkf'
require 'dopp/font/store'

module Dopp
  # Font module.
  module Font
    # Font store.
    STORE ||= Store.new
  end
end
