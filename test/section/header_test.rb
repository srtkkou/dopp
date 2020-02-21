# frozen_string_literal: true

require 'test_helper'
require 'dopp/section/header'

module Dopp
  module Section
    class HeaderTest < Minitest::Test
      def test_ok_initialize
        assert_raises(::Dopp::Error::ApplicationError) do
          Header.new('1.X')
        end
        assert_equal('1.4', Header.new.version)
        assert_equal('1.7', Header.new('1.7').version)
      end

      def test_ok_render
        ex = "%PDF-1.7\n%" +
          [0xE2, 0xE3, 0xCF, 0xD3].pack('C*') + "\n"
        assert_equal(ex, Header.new('1.7').render)
      end
    end
  end
end
