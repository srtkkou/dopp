# frozen_string_literal: true

require 'dopp/util'

module Dopp
  module Section
    # PDF document section "cross reference table".
    class XrefTable
      # Initialize.
      def initialize
        @entries = []
        @entries << XrefTableEntry.new(0, 65535, 'f')
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
      def append(offset, generation, flag)
        entry = XrefTableEntry.new(offset, generation, flag)
        @entries << entry
      end

      # Render to string.
      # @return [String] Content.
      def render
        String.new('xref').concat(LF,
          @entries.map(&:render).join(LF), LF)
      end
    end

    class XrefTableEntry
      FLAGS ||= ::Dopp::Util.deep_freeze([
        'f', # Free entry.
        'n', # In-use entry.
      ])

      attr_reader :offset
      attr_reader :generation
      attr_reader :flag

      # Initialize.
      def initialize(offset, generation = 0, flag = 'n')
        raise(ArgumentError) unless offset.is_a?(Integer)
        raise(ArgumentError) unless generation.is_a?(Integer)
        raise(ArgumentError) unless FLAGS.include?(flag)
        @offset = offset
        @generation = generation
        @flag = flag
      end

      # Render to string.
      # @return [String] Content.
      def render
        '%010d %05d %s' % [@offset, @generation, @flag]
      end
    end
  end
end

