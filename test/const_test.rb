# frozen_string_literal: true

require 'test_helper'

module Dopp
  class ConstTest < Minitest::Test
    def test_ok_version
      refute_nil(::Dopp::VERSION)
      assert_equal(true, VERSION.frozen?)
    end

    def test_ok_application
      assert_equal('dopp', ::Dopp::APP_NAME)
      assert_equal(true, APP_NAME.frozen?)
    end

    def test_ok_lf
      assert_equal("\n", ::Dopp::LF)
      assert_equal(true, LF.frozen?)
    end

    def test_ok_default_pdf_version
      assert_equal('1.4', ::Dopp::DEFAULT_PDF_VERSION)
      assert_equal(true, DEFAULT_PDF_VERSION.frozen?)
    end

    def test_ok_page_sizes
      PAGE_SIZES.each_value do |pair|
        assert_instance_of(Array, pair)
        assert_equal(2, pair.size)
        assert_equal(true, pair.frozen?)
        pair.each do |value|
          assert_kind_of(Numeric, value)
          assert_operator(value, :>, 0.0)
        end
      end
      assert_equal(true, PAGE_SIZES.frozen?)
    end
  end
end
