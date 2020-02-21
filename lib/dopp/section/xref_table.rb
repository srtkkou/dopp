# frozen_string_literal: true

require 'dopp'

module Dopp
  module Section
    # PDF document section "cross reference table".
    class XrefTable
      include ::Dopp::Error

      # Used entry flag.
      IN_USE ||= 'n'

      # Free entry flag.
      FREE ||= 'f'

      # Flags.
      FLAGS ||= ::Dopp::Util.deep_freeze([IN_USE, FREE])

      # Entry struct.
      Entry = Struct.new(:offset, :generation, :flag)

      # Initialize.
      # @param [::Dopp::Document::Structure]
      #   structure PDF document structure.
      def initialize(structure)
        check_is_a!(structure, ::Dopp::Document::Structure)
        @structure = structure
        # Initialize table.
        clear
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
      def append(offset, generation = 0, flag = IN_USE)
        check_is_a!(offset, Integer)
        check_gt!(offset, 0)
        check_is_a!(generation, Integer)
        check_gteq!(generation, 0)
        check_include!(flag, FLAGS)
        entry = Entry.new(offset, generation, flag)
        @entries << entry
      end

      # Clear entries.
      def clear
        first_entry = Entry.new(0, 65_535, 'f')
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
