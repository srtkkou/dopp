# frozen_string_literal: true

require 'forwardable'
require 'dopp/error'
require 'dopp/util'

module Dopp
  module Type
    # PDF object "Array".
    class List
      extend Forwardable
      include ::Dopp::Error

      # Delegate methods of Array.
      def_delegators(
        :@array,
        :<<, :[], :at, :[]=, :include?,
        :empty?, :length, :size
      )

      # Initialize.
      # @params [Array] array Array.
      def initialize(array = [])
        check_is_a!(array, Array)
        @array = array
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        return 'PDF:[]' if @array.empty?

        joined = @array.map(&:to_s).join(', ')
        String.new('PDF:[').concat(joined, ']')
      end

      # Detailed description of this object.
      # @return [String] Description.
      def inspect
        String.new('#<').concat(
          self.class.name, ':',
          object_id.to_s, ' ', to_s, '>'
        )
      end

      # Render to string.
      # @return [String] Content.
      def render
        return '[ ]' if @array.empty?

        joined = @array.map do |v|
          Dopp::Util.pdf_type?(v) ? v.render : v.to_s
        end.join(' ')
        String.new('[').concat(joined, ']')
      end
    end
  end
end
