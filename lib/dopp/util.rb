# frozen_string_literal: true
module Dopp
  # Utilities
  module Util
    module_function

    # Deep freeze.
    def deep_freeze(*args)
      args.each do |arg|
        case arg
        when Hash
          arg.each{|k, v| deep_freeze(k, v)}
          arg.freeze
        when Enumerable
          arg.each{|v| deep_freeze(v)}
          arg.freeze
        else
          arg.freeze unless arg.frozen?
        end
      end
    end
  end
end

