# frozen_string_literal: true
require 'forwardable'

module Dopp
  module Type
    class Dictionary
      extend Forwardable

      # Delegate methods of Hash.
      def_delegators :@content, *(%i[
        [] []= store each empty?
        has_key? key? include? member?
        has_value? value?
        keys length size merge! update
      ])

      # Initialize.
      # @param hash [Hash] Hash argument.
      def initialize(hash = {})
        raise(ArgumentError) unless hash.is_a?(Hash)
        @content = hash
      end

      # Render to String.
      # @return [String] Content.
      def to_s
        return '<< >>' if @content.empty?
        out = '<<' + LF
        @content.each do |k, v|
          out += k.to_s + ' ' + v.to_s + LF
        end
        out += '>>'
        out
      end
    end
  end
end

