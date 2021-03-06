# frozen_string_literal: true

require 'dopp/error'

module Dopp
  module Type
    # PDF type "DateTime"
    class TimeStamp
      include ::Dopp::Error

      # Initialize.
      # @param [Time] time Time.
      def initialize(time)
        check_is_a!(time, Time)
        @time = time
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        String.new('PDF:').concat(
          @time.strftime('%FT%T%:z')
        )
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
        time_str =
          @time.strftime('%Y%m%d%H%M%S%:z').sub(/:/, "'")
        String.new('(D:').concat(time_str, "')")
      end
    end
  end
end
