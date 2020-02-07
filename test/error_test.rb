# frozen_string_literal: true

require 'test_helper'
require 'dopp/error'
require 'dopp/type/key_word'

module Dopp
  class ErrorTest < Minitest::Test
    include ::Dopp::Error

    def test_ok_check_is_a!
      # Integer
      one = 1
      assert_nil(check_is_a!(one, Integer))
      assert_raises(::Dopp::Error::ApplicationError) do
        check_is_a!(one, String)
      end
      # String
      two = '2'
      assert_nil(check_is_a!(two, String))
      assert_raises(::Dopp::Error::ApplicationError) do
        check_is_a!(two, Integer)
      end
      # ::Dopp::Type::KeyWord
      three = ::Dopp::Type::KeyWord.new('3')
      assert_nil(check_is_a!(three, ::Dopp::Type::KeyWord))
      assert_raises(::Dopp::Error::ApplicationError) do
        check_is_a!(three, String)
      end
    end

    def test_ok_check_gt!
      assert_nil(check_gt!(1, 0))
      assert_raises(::Dopp::Error::ApplicationError) do
        check_gt!(1, 1)
      end
      assert_raises(::Dopp::Error::ApplicationError) do
        check_gt!(1, 2)
      end
    end

    def test_ok_check_gteq!
      assert_nil(check_gteq!(1, 0))
      assert_nil(check_gteq!(1, 1))
      assert_raises(::Dopp::Error::ApplicationError) do
        check_gteq!(1, 2)
      end
    end

    def test_ok_include!
      assert_nil(check_include!(1, [3, 2, 1]))
      assert_nil(check_include!(:key, %i[k ke key]))
      assert_raises(::Dopp::Error::ApplicationError) do
        check_include!(1, [4, 3, 2])
      end
      assert_raises(::Dopp::Error::ApplicationError) do
        check_include!(:key, %i[a b c])
      end
    end
  end
end
