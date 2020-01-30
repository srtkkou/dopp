# frozen_string_literal: true
require 'test_helper'
require 'dopp/section/header'

module Dopp
  module Section
    class HeaderTest < Minitest::Test
      def test_OK_render
        tail = [0xE2, 0xE3, 0xCF, 0xD3].pack('c*')
        assert('%PDF-1.0%' + tail, Header.new.to_s)
        assert('%PDF-1.4%' + tail, Header.new('1.4').to_s)
      end
    end
  end
end

