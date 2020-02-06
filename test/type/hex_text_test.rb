# frozen_string_literal: true

require 'test_helper'
require 'dopp/type/hex_text'

module Dopp
  module Type
    class HexTextTest < Minitest::Test
      def test_ok_initialize
        assert_raises(ArgumentError){ HexText.new }
        assert_raises(ArgumentError){ HexText.new(1) }
        assert_raises(ArgumentError){ HexText.new(3.14) }
        assert_raises(ArgumentError){ HexText.new(['a', 'b']) }
        assert_raises(ArgumentError){ HexText.new({a: :b}) }
        xt1 = HexText.new([0xA1, 0xB2, 0xC3])
        assert_equal("PDF:<a1 b2 c3 00>", xt1.to_s)
        xt2 = HexText.new_by_utf8('日本語')
        assert_match(/\APDF:<[0-9a-f ]+>\z/, xt2.to_s)
      end

      def test_ok_render
        xt1 = HexText.new([0xA1, 0xB2, 0xC3])
        assert_equal("<a1b2c300>", xt1.render)
        xt2 = HexText.new_by_utf8('日本語')
        assert_match(/\A<[0-9a-f]+>\z/, xt2.render)
      end
    end
  end
end
