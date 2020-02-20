# frozen_string_literal: true

require 'nkf'
require 'dopp/util'
require 'dopp/font/store'

module Dopp
  # Font module.
  module Font
    extend ::Dopp::Util

    # Font store.
    STORE ||= Store.new

    # Bit masks for "Flags" in font dictionary.
    FLAGS_BIT_MASKS ||= {
      fixed_pitch:  0b00000000_00000000_00000000_00000001,
      serif:        0b00000000_00000000_00000000_00000010,
      symbolic:     0b00000000_00000000_00000000_00000100,
      script:       0b00000000_00000000_00000000_00001000,
      non_symbolic: 0b00000000_00000000_00000000_00100000,
      italic:       0b00000000_00000000_00000000_01000000,
      all_cap:      0b00000000_00000001_00000000_00000000,
      small_cap:    0b00000000_00000010_00000000_00000000,
      force_bold:   0b00000000_00000100_00000000_00000000
    }.tap { |v| deep_freeze(v) }

    # Calculate flags value.
    # @param [Hash] opts Options.
    def flag_value(opts = {})
      opts.inject(0) do |result, (k, v)|
        next result unless v && FLAGS_BIT_MASKS.key?(k)

        result | FLAGS_BIT_MASKS[k]
      end
    end
  end
end
