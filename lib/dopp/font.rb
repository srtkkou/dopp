# frozen_string_literal: true

require 'nkf'

module Dopp
  # Font module.
  module Font
    # Available fonts.
    FONT_MODULES ||= {}

    # Generate font key from name.
    # @param [String] name Font name.
    # @return [String] Font key.
    def self.font_key(name)
      # Change half-width-kana to full-width.
      # - W=UTF-8 input w=UTF-8 output.
      # - Z1=Convert full width space to normal space.
      # - X=Convert half-width-kana to full-width.
      key = NKF.nkf('-W -w -Z1 -X', name)
      # Downcase. Remove hyphen, underscore, and space.
      key.downcase.tr('-_ ', '')
    end
  end
end
