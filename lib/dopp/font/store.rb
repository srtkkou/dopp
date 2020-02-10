# frozen_string_literal: true

require 'nkf'
require 'dopp/error'

module Dopp
  module Font
    # Font store.
    class Store
      include Dopp::Error

      attr_reader :fonts

      # Initialize.
      def initialize
        @modules = {}
      end

      # Get module to initialize font.
      # @param [String] name Font name.
      def font_module(name)
        key = font_key(name)
        mod = @modules[key]
        check_is_a!(mod, Module)
        mod
      end

      # Add module to this font store.
      # @param [String] name Font name.
      # @param [Module] mod Module to add.
      def add_font_module(name, mod)
        key = font_key(name)
        @modules[key] = mod
      end

      # Generate font key.
      # @param [String] name Font name.
      # @param [Hash] opts Font options.
      # @return [String] Font key.
      def font_key(name, opts = {})
        # Change half-width-kana to full-width.
        # - W=UTF-8 input. w=UTF8 output.
        # - Z1=Change full width space to normal space.
        # - X=Change half-width-kana to full-width.
        key = NKF.nkf('-W -w -Z1 -X', name)
        # Downcase and remove hyphens/underscores/spaces.
        key = key.downcase.tr('-_ ', '')
        # Append bold/italic if needed.
        key << 'bold' if opts[:bold]
        key << 'italic' if opts[:italic]
        key
      end
    end
  end
end
