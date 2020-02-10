# frozen_string_literal: true

require 'dopp/error'

module Dopp
  # Utilities
  module Util
    module_function

    # Freeze all the instances in the object.
    # @param [Object] arg Object.
    def deep_freeze(arg)
      case arg
      when Hash
        arg.each do |k, v|
          deep_freeze(k)
          deep_freeze(v)
        end
        arg.freeze
      when Enumerable
        arg.each{ |v| deep_freeze(v) }
        arg.freeze
      else
        arg.freeze unless arg.frozen?
      end
    end

    # Camelize string.
    # @param [String] str String.
    # @return [String] Converted string.
    def camelize(str)
      ::Dopp::Error.check_is_a!(str, String)
      str.gsub(/(?:\A|_)(.)/){ $1.upcase }
    end

    # Is the class of the object defined under Dopp::Type?
    # @param [Object] obj Object.
    # @return [Bool] true=defined, false=not defined.
    def pdf_type?(obj)
      obj.class.name.start_with?('Dopp::Type')
    end

    # Convert millimeters to points.
    # @param [Numeric] millimeters Millimeters.
    # @return [Float] Points.
    def mm_to_pt(millimeters)
      ::Dopp::Error.check_is_a!(millimeters, Numeric)
      points = millimeters * 72.0 / 25.4
      (points * 100.0).round / 100.0
    end

    # Convert points to millimeters.
    # @param [Numeric] points Points.
    # @return [Float] Millimeters.
    def pt_to_mm(points)
      ::Dopp::Error.check_is_a!(points, Numeric)
      millimeters = points * 25.4 / 72.0
      (points * 100.0).round / 100.0
    end
  end
end
