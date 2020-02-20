# frozen_string_literal: true

require 'dopp/error'

module Dopp
  # Utilities
  module Util
    module_function

    # Freeze all the instances in the object.
    # @param [Object] arg Object.
    def deep_freeze(arg)
      if arg.is_a?(Enumerable)
        arg.each do |v|
          deep_freeze(v)
        end
      end
      arg.freeze
    end

    # Deep copy all values in object.
    # @param [Object] obj Object.
    def deep_copy(obj)
      dumped = Marshal.dump(obj)
      Marshal.load(dumped)
    end

    # Camelize string.
    # @param [String] value String.
    # @return [String] Converted string.
    def camelize(value)
      ::Dopp::Error.check_is_a!(value, String)
      value.gsub(/(?:\A|_)(.)/) do |matched|
        matched[-1].upcase
      end
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
      (millimeters * 100.0).round / 100.0
    end
  end
end
