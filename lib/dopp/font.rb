# frozen_string_literal: true

require 'nkf'
require 'dopp/util'
require 'dopp/font/store'

module Dopp
  # Font module.
  module Font
    # Font store.
    STORE ||= Store.new

    # FLAG_BIT_MASKS
    FLAG_BIT_MASKS ||= ::Dopp::Util.deep_freeze(
      fixed_pitch:  0b00000000_00000000_00000000_00000001,
      serif:        0b00000000_00000000_00000000_00000010,
      symbolic:     0b00000000_00000000_00000000_00000100,
      script:       0b00000000_00000000_00000000_00001000,
      non_symbolic: 0b00000000_00000000_00000000_00100000,
      italic:       0b00000000_00000000_00000000_01000000,
      all_cap:      0b00000000_00000001_00000000_00000000,
      small_cap:    0b00000000_00000010_00000000_00000000,
      force_bold:   0b00000000_00000100_00000000_00000000
    )

    module_function

    # Calculate flags value.
    # @param [Hash] opts Options.
    def flag_value(opts = {})
      opts.inject(0) do |result, (k, v)|
        next result unless v && FLAG_BIT_MASKS.key?(k)

        result | FLAG_BIT_MASKS[k]
      end
    end
  end
end
