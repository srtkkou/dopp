# frozen_string_literal: true

require 'test_helper'
require 'dopp/type/list'

module Dopp
  module Type
    class ListTest < Minitest::Test
      def test_ok_delegated
        # empty?
        assert(List.new.empty?)
        # length, size
        list = List.new([0, 1, 2, '3', '4'])
        assert_equal(5, list.size)
        assert_equal(5, list.length)
        # [], at
        assert_equal(0, list[0])
        assert_equal(1, list.at(1))
        assert_equal(2, list[2])
        assert_equal('3', list.at(3))
        assert_equal('4', list[-1])
        # []=
        list[2] = 'NEW2'
        assert_equal('NEW2', list[2])
        # <<
        list << 5
        assert_equal(5, list[-1])
      end

      def test_ok_to_s
        assert_equal('PDF:[]', List.new.to_s)
        assert_equal(
          'PDF:[1, 2, 3, 4]',
          List.new([1, 2, 3, 4]).to_s
        )
      end

      def test_ok_render
        assert_equal('[ ]', List.new.render)
        assert_equal(
          '[1 2 3 4]',
          List.new([1, 2, 3, 4]).render
        )
      end
    end
  end
end
