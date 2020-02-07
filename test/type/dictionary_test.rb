# frozen_string_literal: true
require 'test_helper'
require 'dopp/type/dictionary'
require 'dopp/type/key_word'
require 'dopp/type/text'

module Dopp
  module Type
    class DictionaryTest < Minitest::Test
      def test_OK_delegated
        # empty?
        assert_equal(true, Dictionary.new.empty?)
        # has_key?, key? include?, member?
        d = Dictionary.new(
          {a: 0, b: 1, c: '2', d: '3'})
        assert_equal(true, d.has_key?(:a))
        assert_equal(true, d.key?(:b))
        assert_equal(true, d.include?(:c))
        assert_equal(true, d.member?(:d))
        assert_equal(false, d.key?(:dummy))
        # has_value?, value?
        assert_equal(true, d.has_value?(0))
        assert_equal(true, d.value?('2'))
        assert_equal(false, d.value?(:dummy))
        # keys
        assert_equal([:a, :b, :c, :d], d.keys)
        # length, size
        assert_equal(4, d.size)
        assert_equal(4, d.length)
        # [], []=, store
        assert_equal('3', d[:d])
        d[:d] = 'NEW3'
        assert_equal('NEW3', d[:d])
        d.store(:e, 4)
        assert_equal(4, d[:e])
        assert_nil(d[:dummy])
      end

      def test_OK_to_s
        assert_equal('PDF:{}',
          Dictionary.new.to_s)
        hash = {
          KeyWord.new(:One) => 1,
          KeyWord.new(:Two) => 'b',
          KeyWord.new(:Three) => Text.new('3'),
          KeyWord.new(:Four) => KeyWord.new(:Value)}
        ex = 'PDF:{PDF:/One=>1, PDF:/Two=>b, ' \
          'PDF:/Three=>PDF:"3", PDF:/Four=>PDF:/Value}'
        assert_equal(ex, Dictionary.new(hash).to_s)
      end

      def test_OK_render
        assert_equal('<< >>',
          Dictionary.new.render)
        hash = {
          KeyWord.new(:One) => 1,
          KeyWord.new(:Two) => 'b',
          KeyWord.new(:Three) => Text.new('3'),
          KeyWord.new(:Four) => KeyWord.new(:Value)}
        ex = <<~"EOS"
<<
/One 1
/Two b
/Three (3)
/Four /Value
>>
        EOS
        assert_equal(ex.chomp, Dictionary.new(hash).render)
      end
    end
  end
end

