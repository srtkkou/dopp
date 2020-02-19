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
        @builders = {}
      end

      # Get class to build font.
      # @param [String] name Font name.
      def font_builder(name)
        key = font_key(name)
        klass = @builders[key]
        check_is_a!(klass, Class)
        klass
      end

      # Add module to this font store.
      # @param [String] name Font name.
      # @param [Class] klass Builder class to add.
      def add_font_builder(name, klass)
        check_is_a!(klass, Class)
        key = font_key(name)
        @builders[key] = klass
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
