# frozen_string_literal: true
require 'test_helper'
require 'dopp/type/list'

module Dopp
  module Type
    class ListTest < Minitest::Test
      def test_OK_delegated
        list = List.new(0, 1, 2, '3', '4')
        # length, size
        assert_equal(5, list.size)
        assert_equal(5, list.length)
        # [], at
        assert_equal(list[0], 0)
        assert_equal(list.at(1), 1)
        assert_equal(list[2], 2)
        assert_equal(list.at(3), '3')
        assert_equal(list[-1], '4')
        # []=
        list[2] = 'NEW2'
        assert_equal(list[2], 'NEW2')
        # <<
        list << 5
        assert_equal(list[-1], 5)
      end

      def test_OK_to_s
        assert_equal('[ ]', List.new().to_s)
        assert_equal('[1 2 3 4]', List.new(1, 2, 3, 4).to_s)
      end
    end
  end
end

