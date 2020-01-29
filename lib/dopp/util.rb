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

    # Camelize text or symbol.
    # @param obj [String|Symbol] Text.
    # @return [String] Converted string.
    def camelize(obj)
      obj = obj.to_s unless obj.is_a?(String)
      obj.gsub(/(?:\A|_)(.)/){$1.upcase}
    end

    # Convert millimeters to points.
    # @param mm [Numeric] Millimeters.
    # @return [Numeric] Points.
    def mm_to_pt(mm)
      raise(ArgumentError) unless mm.is_a?(Numeric)
      pt = mm * 72.0 / 25.4
      (pt * 100.0).round / 100.0
    end

    # Convert points to millimeters.
    # @param pt [Numeric] Points.
    # @return [Numeric] Millimeters.
    def pt_to_mm(pt)
      raise(ArgumentError) unless pt.is_a?(Numeric)
      mm = pt * 25.4 / 72.0
      (mm * 100.0).round / 100.0
    end
  end
end

