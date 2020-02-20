# frozen_string_literal: false

require 'test_helper'
require 'dopp/error'
require 'dopp/type'

module Dopp
  module Util
    class UtilTest < Minitest::Test
      include Dopp::Util

      def test_ok_deep_freeze_hash_in_array
        obj = [
          { a: '1', 'b' => '2', 'c' => [3, 4, { 'd' => '5' }] }, 6
        ]
        assert_equal(false, obj.frozen?)
        assert_equal(false, obj[0].frozen?)
        assert_equal(false, obj[0][:a].frozen?)
        assert_equal(false, obj[0]['b'].frozen?)
        assert_equal(false, obj[0]['c'].frozen?)
        assert_equal(false, obj[0]['c'][2].frozen?)
        assert_equal(false, obj[0]['c'][2]['d'].frozen?)
        deep_freeze(obj)
        assert_equal(true, obj.frozen?)
        assert_equal(true, obj[0].frozen?)
        assert_equal(true, obj[0][:a].frozen?)
        assert_equal(true, obj[0]['b'].frozen?)
        assert_equal(true, obj[0]['c'].frozen?)
        assert_equal(true, obj[0]['c'][2].frozen?)
        assert_equal(true, obj[0]['c'][2]['d'].frozen?)
      end

      def test_ok_deep_freeze_array_in_hash
        obj = {
          a: '1', 'b' => '2', 'c' => [3, 4, { 'd' => '5' }]
        }
        assert_equal(false, obj.frozen?)
        assert_equal(false, obj[:a].frozen?)
        assert_equal(false, obj['b'].frozen?)
        assert_equal(false, obj['c'].frozen?)
        assert_equal(false, obj['c'][2].frozen?)
        assert_equal(false, obj['c'][2]['d'].frozen?)
        deep_freeze(obj)
        assert_equal(true, obj.frozen?)
        assert_equal(true, obj[:a].frozen?)
        assert_equal(true, obj['b'].frozen?)
        assert_equal(true, obj['c'].frozen?)
        assert_equal(true, obj['c'][2].frozen?)
        assert_equal(true, obj['c'][2]['d'].frozen?)
      end

      def test_ok_camelize
        assert_equal('CamelCase', camelize('camel_case'))
        assert_raises(::Dopp::Error::ApplicationError) do
          camelize(:symbol_to_camel)
        end
      end

      def test_ok_pdf_type?
        assert_equal(false, pdf_type?(1))
        assert_equal(false, pdf_type?(3.14))
        assert_equal(false, pdf_type?('string'))
        assert_equal(false, pdf_type?(:symbol))
        assert_equal(true, pdf_type?(Dopp::Type.text('text')))
      end
    end
  end
end
