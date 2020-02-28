# frozen_string_literal: true

require 'dopp/shape/text_area'

module Dopp
  # Shape.
  module Shape
    # Add sub methods when included.
    def self.included(mod)
      mod.define_method(
        :text_area,
        ->(text, opts = {}) do
          TextArea.new(self, text, opts).render
        end
      )
    end
  end
end
