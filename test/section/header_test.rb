# frozen_string_literal: true

require 'test_helper'
require 'dopp/section/header'

module Dopp
  module Section
    class HeaderTest < Minitest::Test
      def test_ok_initialize
        assert_raises(::Dopp::Error::ApplicationError) do
          Header.new(pdf_version: '1.X')
        end
        h1 = Header.new
        assert_equal('1.4', h1.pdf_version)
        h1.pdf_version = '1.6'
        assert_equal('1.6', h1.pdf_version)
        h2 = Header.new(pdf_version: '1.7')
        assert_equal('1.7', h2.pdf_version)
      end

      def test_ok_render
        ex = String.new("%PDF-1.7\n%")
        ex << [0xE2, 0xE3, 0xCF, 0xD3].pack('C*')
        ex << "\n"
        h1 = Header.new(pdf_version: '1.7')
        assert_equal(ex, h1.render)
      end
    end
  end
end
