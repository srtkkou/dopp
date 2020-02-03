# frozen_string_literal: false
require 'test_helper'
require 'dopp/type'

class UtilTest < Minitest::Test
  include Dopp::Util

  def test_OK_deep_freeze_array_and_hash
    obj = [{a: '1', 'b' => "2", c: [3, 4, {d: '5'}]}, 6]
    assert(!obj.frozen?)
    assert(!obj[0].frozen?)
    assert(!obj[0][:a].frozen?)
    assert(!obj[0]['b'].frozen?)
    assert(!obj[0][:c].frozen?)
    assert(!obj[0][:c][2].frozen?)
    assert(!obj[0][:c][2][:d].frozen?)
    deep_freeze(obj)
    assert(obj.frozen?)
    assert(obj[0].frozen?)
    assert(obj[0][:a].frozen?)
    assert(obj[0]['b'].frozen?)
    assert(obj[0][:c].frozen?)
    assert(obj[0][:c][2].frozen?)
    assert(obj[0][:c][2][:d].frozen?)
  end

  def test_OK_camelize
    assert_equal('CamelCase', camelize('camel_case'))
  end

  def test_NG_camelize
    assert_raises(ArgumentError){camelize(:symbol_to_camel)}
  end

  def test_OK_pdf_type?
    assert(!pdf_type?(1))
    assert(!pdf_type?(3.14))
    assert(!pdf_type?('string'))
    assert(!pdf_type?(:symbol))
    assert(pdf_type?(Dopp::Type.text('text')))
  end
end

