# frozen_string_literal: true

require 'test_helper'

module Dopp
  class ConstTest < Minitest::Test
    def test_ok_version
      refute_nil(VERSION)
      assert_includes(::Dopp.constants, :VERSION)
      assert_equal(true, VERSION.frozen?)
    end

    def test_ok_application
      assert_equal('dopp', APPLICATION)
      assert_includes(::Dopp.constants, :APPLICATION)
      assert_equal(true, APPLICATION.frozen?)
    end

    def test_ok_lf
      assert_equal("\n", LF)
      assert_includes(::Dopp.constants, :LF)
      assert_equal(true, LF.frozen?)
    end
  end
end
