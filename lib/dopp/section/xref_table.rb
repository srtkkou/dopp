# frozen_string_literal: true

require 'dopp/util'
require 'dopp/type'

module Dopp
  module Section
    # PDF document section "cross reference table".
    class XrefTable
      # Used entry flag.
      IN_USE ||= 'n'

      # Free entry flag.
      FREE ||= 'f'

      # Flags.
      FLAGS ||= ::Dopp::Util.deep_freeze([
        IN_USE, FREE])

      # Entry struct.
      Entry = Struct.new(:offset, :generation, :flag)

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        raise(ArgumentError) unless doc.is_a?(::Dopp::Document)
        @document = doc
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
        raise(ArgumentError) unless
          (offset.is_a?(Integer) && offset > 0)
        raise(ArgumentError) unless
          (generation.is_a?(Integer) && generation >= 0)
        raise(ArgumentError) unless FLAGS.include?(flag)
        entry = Entry.new(offset, generation, flag)
        @entries << entry
      end

      # Clear entries.
      def clear
        first_entry = Entry.new(0, 65535, 'f')
        @entries = [first_entry]
      end

      # Render to string.
      # @return [String] Content.
      def render
        table = @entries.map{|e|
          '%010d %05d %s' % e.to_a
        }.join(LF)
        String.new('xref').concat(LF, table, LF)
      end
    end
  end
end
