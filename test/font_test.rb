# frozen_string_literal: false

require 'test_helper'
require 'dopp/font'

module Dopp
  module Font
    class UtilTest < Minitest::Test
      def test_ok_font_key
        assert_equal('timesroman', Font.font_key('Times-Roman'))
        assert_equal('timesroman', Font.font_key('Times_Roman'))
        assert_equal('timesroman', Font.font_key('Times Roman'))
        assert_equal('msゴシック', Font.font_key('MS ゴシック'))
        assert_equal('msゴシック', Font.font_key('MS ｺﾞｼｯｸ'))
        assert_equal('msゴシック', Font.font_key('ＭＳ　ゴシック'))
      end
    end
  end
end
