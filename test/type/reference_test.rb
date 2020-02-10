# frozen_string_literal: true

require 'test_helper'
require 'dopp/error'
require 'dopp/type/reference'

module Dopp
  module Type
    class ReferenceTest < Minitest::Test
      def test_ok_initialize
        # Test ID.
        assert_raises(::Dopp::Error::ApplicationError) do
          Reference.new('1')
        end
        assert_raises(::Dopp::Error::ApplicationError) do
          Reference.new(3.14)
        end
        assert_raises(::Dopp::Error::ApplicationError) do
          Reference.new(0)
        end
        assert_equal('PDF:1-0R', Reference.new(1).to_s)
        # Test reviion.
        assert_raises(::Dopp::Error::ApplicationError) do
          Reference.new(1, '1')
        end
        assert_raises(::Dopp::Error::ApplicationError) do
          Reference.new(1, 3.14)
        end
        assert_raises(::Dopp::Error::ApplicationError) do
          Reference.new(1, -1)
        end
        assert_equal('PDF:2-3R', Reference.new(2, 3).to_s)
      end

      def test_ok_render
        assert_equal('1 0 R', Reference.new(1).render)
        assert_equal('2 3 R', Reference.new(2, 3).render)
      end
    end
  end
end

