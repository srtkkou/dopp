# frozen_string_literal: true
require 'test_helper'
require 'dopp/type/name'

module Dopp
  module Type
    class NameTest < Minitest::Test
      def test_OK_initialize
        assert_raises(ArgumentError){Name.new(1)}
        assert_raises(ArgumentError){Name.new(3.14)}
        assert_raises(ArgumentError){Name.new(['a', 'b'])}
        assert('/a', Name.new('a').render)
        assert('/b', Name.new(:b).render)
      end

      def test_OK_eql?
        ex = Name.new('test')
        # Not equal to String/Symbol.
        assert(!ex.eql?('/test'))
        assert(!ex.eql?(:'/test'))
        # Equal to other instance.
        assert(ex.eql?(Name.new('test')))
        assert(ex.eql?(Name.new(:test)))
      end

      def test_OK_render
        assert_equal('/test', Name.new('test').render)
        assert_equal('/test', Name.new(:test).render)
      end

      def test_OK_as_Hash_key
        h = {Name.new('key') => 1}
        assert(h.key?(Name.new('key')))
        assert_equal(1, h[Name.new('key')])
      end
    end
  end
end

