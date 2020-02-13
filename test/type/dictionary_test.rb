# frozen_string_literal: true

require 'test_helper'
require 'dopp/type/dictionary'
require 'dopp/type/key_word'
require 'dopp/type/text'

module Dopp
  module Type
    class DictionaryTest < Minitest::Test
      def test_ok_get_set
        d = Dictionary.new
        # empty?
        assert_equal(true, d.empty?)
        # []=
        d[:key1] = 1
        d['key2'] = :value2
        d[:key3] = :value3
        d['key4'] = 4
        # []
        assert_equal(false, d.key?(:key1))
        assert_equal(1, d[KeyWord.new(:key1)])
        assert_equal(KeyWord.new(:value2), d['key2'])
        assert_equal(false, d.key?(:key3))
        assert_equal(KeyWord.new(:value3), d[KeyWord.new(:key3)])
        assert_equal(4, d['key4'])
        assert_nil(d[:dummy])
      end

      def test_ok_delegated
        # key? include?
        d = Dictionary.new(
          a: 0, 'b' => :x, c: '2', 'd' => '3'
        )
        assert_equal(true, d.key?(KeyWord.new(:a)))
        assert_equal(true, d.key?('b'))
        assert_equal(true, d.include?(KeyWord.new(:c)))
        assert_equal(true, d.include?('d'))
        assert_equal(false, d.key?(:dummy))
        assert_equal(false, d.key?(:a))
        # value?
        assert_equal(true, d.value?(0))
        assert_equal(true, d.value?(KeyWord.new(:x)))
        assert_equal(false, d.value?(:dummy))
        # keys
        assert_equal(
          [KeyWord.new(:a), 'b', KeyWord.new(:c), 'd'], d.keys
        )
        # size
        assert_equal(4, d.size)
      end

      def test_ok_to_s
        assert_equal('PDF:{}', Dictionary.new.to_s)
        d = Dictionary.new(
          One: 1, Two: 'b', Three: Text.new('3'), Four: :Value
        )
        ex = 'PDF:{PDF:/One=>1, PDF:/Two=>b, '\
          'PDF:/Three=>PDF:"3", PDF:/Four=>PDF:/Value}'
        assert_equal(ex, d.to_s)
      end

      def test_ok_render
        assert_equal('<< >>', Dictionary.new.render)
        d = Dictionary.new(
          One: 1, Two: 'b', Three: Text.new('3'), Four: :Value
        )
        ex = "<<\n/One 1\n/Two b\n/Three (3)\n/Four /Value\n>>"
        assert_equal(ex, d.render)
      end
    end
  end
end
