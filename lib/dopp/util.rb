# frozen_string_literal: true
module Dopp
  # Utilities
  module Util
    module_function

    # Deep freeze.
    def deep_freeze(arg)
      case arg
      when Hash
        arg.each do |k, v|
          deep_freeze(k)
          deep_freeze(v)
        end
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

