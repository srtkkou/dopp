# frozen_string_literal: true
require 'test_helper'
require 'dopp/section/object_header'

module Dopp
  module Section
    class ObjectHeaderTest < Minitest::Test
      def test_OK_render
        h = ObjectHeader.new
        h.id = 1
        assert("1 0a obj\n", h.render)
        h.id = 2
        h.revision = 3
        assert("2 3a obj\n", h.render)
      end
    end
  end
end

