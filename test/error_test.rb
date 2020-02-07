# frozen_string_literal: true

require 'test_helper'
require 'dopp/error'
require 'dopp/type/key_word'

module Dopp
  class ErrorTest < Minitest::Test
    def test_ok_check_is_a!
      err = ::Dopp::Error
      # Integer
      one = 1
      assert_nil(err.check_is_a!(one, Integer))
      assert_raises(err){ err.check_is_a!(one, String) }
      # String
      two = '2'
      assert_nil(err.check_is_a!(two, String))
      assert_raises(err){ err.check_is_a!(two, Integer) }
      # ::Dopp::Type::KeyWord
      three = ::Dopp::Type::KeyWord.new('3')
      assert_nil(err.check_is_a!(three, ::Dopp::Type::KeyWord))
      assert_raises(err){ err.check_is_a!(three, String) }
    end

    def test_ok_check_gt!
      err = ::Dopp::Error
      assert_nil(err.check_gt!(1, 0))
      assert_raises(err){ err.check_gt!(1, 1) }
      assert_raises(err){ err.check_gt!(1, 2) }
    end

    def test_ok_check_gteq!
      err = ::Dopp::Error
      assert_nil(err.check_gteq!(1, 0))
      assert_nil(err.check_gteq!(1, 1))
      assert_raises(err){ err.check_gteq!(1, 2) }
    end

    def test_ok_include!
      err = ::Dopp::Error
      assert_nil(err.check_include!(1, [3, 2, 1]))
      assert_nil(err.check_include!(:key, %i[k ke key]))
      assert_raises(err){ err.check_include!(1, [4, 3, 2]) }
      assert_raises(err){ err.check_include!(:key, %i[a b c]) }
    end
  end
end
