# frozen_string_literal: true

require 'test_helper'
require 'dopp/type/text'

module Dopp
  module Type
    class TextTest < Minitest::Test
      def test_ok_initialize
        assert_raises(ArgumentError){Text.new}
        assert_raises(ArgumentError){Text.new(1)}
        assert_raises(ArgumentError){Text.new(3.14)}
        assert_raises(ArgumentError){Text.new(['a', 'b'])}
        assert_raises(ArgumentError){Text.new({a: :b})}
        assert_equal('PDF:"a"', Text.new('a').to_s)
      end

      def test_ok_render
        assert_equal('(a)', Text.new('a').render)
      end
    end
  end
end

