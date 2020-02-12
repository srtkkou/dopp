# frozen_string_literal: true

require 'dopp/error'

module Dopp
  # Utilities
  module Util
    module_function

    # Freeze all the instances in the object.
    # @param [Object] arg Object.
    def deep_freeze(arg)
      arg.freeze unless arg.frozen?
      if arg.is_a?(Hash)
        arg.each do |k, v|
          deep_freeze(k)
          deep_freeze(v)
        end
      elsif arg.is_a?(Enumerable)
        arg.each do |v|
          deep_freeze(v)
        end
      end
      arg
    end

    # Camelize string.
    # @param [String] str String.
    # @return [String] Converted string.
    def camelize(str)
      ::Dopp::Error.check_is_a!(str, String)
      str.gsub(/(?:\A|_)(.)/) { $1.upcase }
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

    # Convert CSS color code to PDF color code.
    # @param [String] code CSS color code. (Example: "#FF00FF").
    # @return [String] PDF color code.
    def css_color_to_color(code)
      matched = /\A#?(\h{2})(\h{2})(\h{2})\z/.match(code)
      ::Dopp::Error.check_is_a!(matched, MatchData)
      values = matched.captures.map { |s| s.to_i(16) }
      rgb_to_color(*values)
    end

    # Convert RGB color code to PDF color code.
    # @param [Numeric] red Color code for R.
    # @param [Numeric] green Color code for G.
    # @param [Numeric] blue Color code for B.
    # @return [String] PDF color code.
    def rgb_to_color(red, green, blue)
      [red, green, blue].map do |value|
        ::Dopp::Error.check_is_a!(value, Numeric)
        ::Dopp::Error.check_gteq!(value, 0.0)
        ::Dopp::Error.check_lteq!(value, 255.0)
        code = value / 255.0
        format('%<code>.2f', code: code)
      end.join(' ')
    end
  end
end
