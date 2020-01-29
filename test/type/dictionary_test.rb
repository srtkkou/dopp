# frozen_string_literal: true
require 'test_helper'
require 'dopp/type/dictionary'

module Dopp
  module Type
    class DictionaryTest < Minitest::Test
      def test_OK_delegated
        # empty?
        assert(Dictionary.new.empty?)
        # has_key?, key? include?, member?
        dict = Dictionary.new(
          {a: 0, b: 1, c: '2', d: '3'})
        assert(dict.has_key?(:a))
        assert(dict.key?(:b))
        assert(dict.include?(:c))
        assert(dict.member?(:d))
        assert(!dict.key?(:dummy))
        # has_value?, value?
        assert(dict.has_value?(0))
        assert(dict.value?('2'))
        assert(!dict.value?(:dummy))
        # keys
        assert_equal([:a, :b, :c, :d], dict.keys)
        # length, size
        assert_equal(4, dict.size)
        assert_equal(4, dict.length)
        # [], []=, store
        assert_equal('3', dict[:d])
        dict[:d] = 'NEW3'
        assert_equal('NEW3', dict[:d])
        dict.store(:e, 4)
        assert_equal(4, dict[:e])
        assert_nil(dict[:dummy])
      end

      def test_OK_to_s
        assert_equal('<< >>', Dictionary.new.to_s)
        hash = {
          Name.new('One') => 1,
          Name.new('Two') => 2}
        ex = <<~"EOS"
<<
/One 1
/Two 2
>>
        EOS
        assert_equal(ex.chomp, Dictionary.new(hash).to_s)
      end
    end
  end
end

