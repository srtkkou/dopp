# frozen_string_literal: true
module Dopp
  module Type
    class TimeStamp
      # Initialize.
      # @param time [Time] Time.
      def initialize(time)
        raise(ArgumentError) unless time.is_a?(Time)
        @content = ('(D:' +
          time.strftime('%Y%m%d%H%M%S%:z').sub(/:/, "'") +
        "')").freeze
      end

      # Render to String.
      # @return [String] Content.
      def to_s
        @content
      end
    end
  end
end

