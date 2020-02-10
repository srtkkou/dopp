# frozen_string_literal: false

require 'test_helper'
require 'dopp/font'

module Dopp
  module Font
    class StoreTest < Minitest::Test
      def test_ok_font_key
        store = ::Dopp::Font::Store.new
        assert_equal('timesroman', store.font_key('Times-Roman'))
        assert_equal('timesroman', store.font_key('Times_Roman'))
        assert_equal('timesroman', store.font_key('Times Roman'))
        assert_equal('timesromanbold',
          store.font_key('Times Roman', bold: true))
        assert_equal('timesromanitalic',
          store.font_key('Times Roman', italic: true))
        assert_equal('timesromanbolditalic',
          store.font_key('Times Roman', italic: true, bold: true))
        assert_equal('msゴシック', store.font_key('MS ゴシック'))
        assert_equal('msゴシック', store.font_key('MS ｺﾞｼｯｸ'))
        assert_equal('msゴシック', store.font_key('ＭＳ　ゴシック'))
        assert_equal('msゴシックbold',
          store.font_key('ＭＳ　ゴシック', bold: true))
        assert_equal('msゴシックitalic',
          store.font_key('ＭＳ　ゴシック', italic: true))
        assert_equal('msゴシックbolditalic',
          store.font_key('ＭＳ　ゴシック', bold: true, italic: true))
      end
    end
  end
end
