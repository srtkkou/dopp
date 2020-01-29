# frozen_string_literal: true
require 'test_helper'
require 'dopp/type/hex_text'

module Dopp
  module Type
    class HexTextTest < Minitest::Test
      def test_OK_initialize
        assert_raises(ArgumentError){HexText.new}
        assert_raises(ArgumentError){HexText.new(1)}
        assert_raises(ArgumentError){HexText.new(3.14)}
        assert_raises(ArgumentError){HexText.new(['a', 'b'])}
        assert_raises(ArgumentError){HexText.new({a: :b})}
        xtext = HexText.new('日本語')
        assert(/\A<[0-9A-F]+>\z/, xtext.to_s)
      end
    end
  end
end

