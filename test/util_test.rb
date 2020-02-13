# frozen_string_literal: false

require 'test_helper'
require 'dopp/error'
require 'dopp/type'

class UtilTest < Minitest::Test
  include Dopp::Util

  def test_ok_deep_freeze_array_and_hash
    obj = [
      { a: '1', 'b' => '2', c: [3, 4, { d: '5' }] }, 6
    ]
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

  def test_ok_css_color_to_color
    assert_equal('0.00 0.00 0.00', css_color_to_color('#000000'))
    assert_equal('1.00 1.00 1.00', css_color_to_color('FFFFFF'))
    assert_raises(::Dopp::Error::ApplicationError) do
      css_color_to_color('#BCDEFG')
    end
    assert_raises(::Dopp::Error::ApplicationError) do
      css_color_to_color('#ABCDE')
    end
  end

  def test_ok_rgb_to_color
    assert_equal('0.00 0.00 0.00', rgb_to_color(0, 0, 0))
    assert_equal('1.00 1.00 1.00', rgb_to_color(255.0, 255.0, 255.0))
    assert_raises(::Dopp::Error::ApplicationError) do
      rgb_to_color('FF', 0, 0)
    end
    assert_raises(::Dopp::Error::ApplicationError) do
      rgb_to_color(-1, 0, 0)
    end
    assert_raises(::Dopp::Error::ApplicationError) do
      rgb_to_color(0, 255.1, 0)
    end
  end
end
