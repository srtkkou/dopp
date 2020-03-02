# frozen_string_literal: true

require 'dopp/shape/text_area'

module Dopp
  # Shape.
  module Shape
    # Text area.
    def text_area(text, opts = {})
      TextArea.new(self, text, opts).render
    end
  end
end
