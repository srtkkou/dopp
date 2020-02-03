# frozen_string_literal: true
require 'test_helper'
require 'dopp/type/name'
require 'dopp/type/text'

module Dopp
  module Type
    class NameTest < Minitest::Test
      def test_OK_initialize
        assert_raises(ArgumentError){Name.new(1)}
        assert_raises(ArgumentError){Name.new(3.14)}
        assert_raises(ArgumentError){Name.new(['a', 'b'])}
        assert_equal('PDF:/a', Name.new(:a).to_s)
        assert_equal('PDF:/b', Name.new('b').to_s)
      end

      def test_OK_as_Hash_key
        h = {Name.new(:key1) => 1}
        assert_equal(true, h.key?(Name.new(:key1)))
        assert_equal(true, h.key?(Name.new('key1')))
        assert_equal(1, h[Name.new(:key1)])
        assert_equal(1, h[Name.new('key1')])
      end

      def test_NG_as_Hash_key
        h = {Name.new('key2') => 2}
        assert_equal(false, h.key?(:key2))
        assert_equal(false, h.key?('key2'))
        assert_equal(false, h.key?(Text.new('key2')))
        assert_nil(h[:key2])
        assert_nil(h['key2'])
        assert_nil(h[Text.new('key2')])
      end

      def test_OK_render
        assert_equal('/test', Name.new(:test).render)
        assert_equal('/test', Name.new('test').render)
      end
    end
  end
end

