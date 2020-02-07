# frozen_string_literal: true
require 'test_helper'
require 'dopp/type/key_word'
require 'dopp/type/text'

module Dopp
  module Type
    class KeyWordTest < Minitest::Test
      def test_ok_initialize
        assert_raises(ArgumentError){KeyWord.new(1)}
        assert_raises(ArgumentError){KeyWord.new(3.14)}
        assert_raises(ArgumentError){KeyWord.new(['a', 'b'])}
        assert_equal('PDF:/a', KeyWord.new(:a).to_s)
        assert_equal('PDF:/b', KeyWord.new('b').to_s)
      end

      def test_ok_as_hash_key
        h = {KeyWord.new(:key1) => 1}
        assert_equal(true, h.key?(KeyWord.new(:key1)))
        assert_equal(true, h.key?(KeyWord.new('key1')))
        assert_equal(1, h[KeyWord.new(:key1)])
        assert_equal(1, h[KeyWord.new('key1')])
      end

      def test_ng_as_Hash_key
        h = {KeyWord.new('key2') => 2}
        assert_equal(false, h.key?(:key2))
        assert_equal(false, h.key?('key2'))
        assert_equal(false, h.key?(Text.new('key2')))
        assert_nil(h[:key2])
        assert_nil(h['key2'])
        assert_nil(h[Text.new('key2')])
      end

      def test_ok_render
        assert_equal('/test', KeyWord.new(:test).render)
        assert_equal('/test', KeyWord.new('test').render)
      end
    end
  end
end

