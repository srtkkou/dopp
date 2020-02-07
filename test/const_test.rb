# frozen_string_literal: true

require 'test_helper'

class ConstTest < Minitest::Test
  def test_ok_constants
    refute_nil(::Dopp::VERSION)
    assert_equal('dopp', ::Dopp::APPLICATION)
    assert_equal("\n", ::Dopp::LF)
  end
end
