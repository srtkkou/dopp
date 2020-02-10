# frozen_string_literal: true

require 'test_helper'
require 'dopp/error'
require 'dopp/type/text'

module Dopp
  module Type
    class TextTest < Minitest::Test
      def test_ok_initialize
        assert_raises(::Dopp::Error::ApplicationError) do
          Text.new(1)
        end
        assert_raises(::Dopp::Error::ApplicationError) do
          Text.new(3.14)
        end
        assert_raises(::Dopp::Error::ApplicationError) do
          Text.new(['a', 'b'])
        end
        assert_raises(::Dopp::Error::ApplicationError) do
          Text.new({a: :b})
        end
        assert_equal('PDF:"a"', Text.new('a').to_s)
      end

      def test_ok_render
        assert_equal('(a)', Text.new('a').render)
      end
    end
  end
end

