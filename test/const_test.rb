# frozen_string_literal: true
require 'test_helper'

class ConstTest < Minitest::Test
  def test_OK_const_VERSION_exists
    refute_nil(::Dopp::VERSION)
  end

  def test_OK_const_APPLICATION
    assert_equal('dopp', ::Dopp::APPLICATION)
  end

  def test_OK_const_LF
    assert_equal("\n", ::Dopp::LF)
  end
end

