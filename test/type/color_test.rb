# frozen_string_literal: false

require 'test_helper'
require 'dopp/error'
require 'dopp/type'

module Dopp
  module Type
    class ColorTest < Minitest::Test
      include Dopp::Util

      def test_ok_initialize
        assert_raises(::Dopp::Error::ApplicationError) do
          Color.new('#BCDEFG')
        end
        assert_raises(::Dopp::Error::ApplicationError) do
          Color.new('#ABCDE')
        end
        assert_equal('PDF:#000000', Color.new('#000000').to_s)
        assert_equal('PDF:#ffffff', Color.new('FFFFFF').to_s)
      end

      def test_ok_render
        assert_equal('0.00 0.00 0.00', Color.new('#000000').render)
        assert_equal('0.40 0.40 0.40', Color.new('666666').render)
        assert_equal('1.00 1.00 1.00', Color.new('FFFFFF').render)
      end
     end
  end
end
