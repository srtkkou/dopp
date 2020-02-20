# frozen_string_literal: false

require 'test_helper'
require 'dopp/error'
require 'dopp/type'

module Dopp
  class UtilTest < Minitest::Test
    include Dopp::Util

    def test_ok_deep_freeze_hash_in_array
      obj = [
        { a: '1', 'b' => '2', 'c' => [3, 4, { 'd' => '5' }] }, 6
      ]
      assert(!obj.frozen?)
      assert(!obj[0].frozen?)
      assert(!obj[0][:a].frozen?)
      assert(!obj[0]['b'].frozen?)
      assert(!obj[0]['c'].frozen?)
      assert(!obj[0]['c'][2].frozen?)
      assert(!obj[0]['c'][2]['d'].frozen?)
      deep_freeze(obj)
      assert(obj.frozen?)
      assert(obj[0].frozen?)
      assert(obj[0][:a].frozen?)
      assert(obj[0]['b'].frozen?)
      assert(obj[0]['c'].frozen?)
      assert(obj[0]['c'][2].frozen?)
      assert(obj[0]['c'][2]['d'].frozen?)
    end

    def test_ok_deep_freeze_array_in_hash
      obj = {
        a: '1', 'b' => '2', 'c' => [3, 4, { 'd' => '5' }]
      }
      assert(!obj.frozen?)
      assert(!obj[:a].frozen?)
      assert(!obj['b'].frozen?)
      assert(!obj['c'].frozen?)
      assert(!obj['c'][2].frozen?)
      assert(!obj['c'][2]['d'].frozen?)
      deep_freeze(obj)
      assert(obj.frozen?)
      assert(obj[:a].frozen?)
      assert(obj['b'].frozen?)
      assert(obj['c'].frozen?)
      assert(obj['c'][2].frozen?)
      assert(obj['c'][2]['d'].frozen?)
    end

    def test_ok_camelize
      assert_equal('CamelCase', camelize('camel_case'))
      assert_raises(::Dopp::Error::ApplicationError) do
        camelize(:symbol_to_camel)
      end
    end

    def test_ok_pdf_type?
      assert(!pdf_type?(1))
      assert(!pdf_type?(3.14))
      assert(!pdf_type?('string'))
      assert(!pdf_type?(:symbol))
      assert(pdf_type?(Dopp::Type.text('text')))
    end
  end
end
