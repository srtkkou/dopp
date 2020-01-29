# frozen_string_literal: true
module Dopp
  module Type
    class TimeStamp
      # Initialize.
      # @param time [Time] Time.
      def initialize(time)
        raise(ArgumentError) unless time.is_a?(Time)
        time_str = time.strftime('%Y%m%d%H%M%S%:z').
          sub(/:/, "'")
        @content = Text.new('D;' + time_str + "'")
      end

      # Render to String.
      # @return [String] Content.
      def to_s
        @content
      end
    end
  end
end

