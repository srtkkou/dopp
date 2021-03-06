# frozen_string_literal: true

require 'dopp/error'
require 'dopp/util'

module Dopp
  module Section
    # PDF document section "cross reference table".
    class XrefTable
      include ::Dopp::Error

      # Flags.
      FLAGS ||= ::Dopp::Util.deep_freeze(
        in_use: 'n', free: 'f'
      )

      # Entry struct.
      Entry = Struct.new(:offset, :generation, :flag)

      # Initialize.
      def initialize
        clear_entries
      end

      # Get size of the entries.
      # @return [Integer] size Size of the entries.
      def entry_size
        @entries.size
      end

      # Append new entry.
      # @param [Integer] offset Offset from the start of file.
      # @param [Integer] generation PDF object generation.
      # @param [String] flag Flag of the entry.
      def append(offset, generation = 0, flag = :in_use)
        check_is_a!(offset, Integer)
        check_gt!(offset, 0)
        check_is_a!(generation, Integer)
        check_gteq!(generation, 0)
        check_include!(flag, FLAGS)
        @entries << Entry.new(offset, generation, flag)
      end

      # Clear entries.
      def clear_entries
        first_entry = Entry.new(0, 65_535, FLAGS[:free])
        @entries = [first_entry]
      end

      # Render to string.
      # @return [String] Content.
      def render
        table = @entries.map do |e|
          format('%<offset>010d %<generation>05d %<flag>s', e.to_h)
        end.join(LF)
        String.new('xref').concat(LF, table, LF)
      end
    end
  end
end
