# frozen_string_literal: true

require 'forwardable'
require 'dopp/error'
require 'dopp/util'
require 'dopp/type/key_word'

module Dopp
  module Type
    # PDF type "Dictionary".
    class Dictionary
      extend Forwardable
      include ::Dopp::Error

      # Delegate methods of Hash.
      def_delegators(
        :@hash,
        :key?, :value?, :each, :empty?, :include?,
        :keys, :size, :merge!, :update
      )

      # Initialize.
      # @param [Hash] hash Hash argument.
      def initialize(hash = {})
        check_is_a!(hash, Hash)
        @hash = {}
        hash.each { |k, v| self[k] = v }
      end

      # Get value by key.
      # @param [Object] key Key.
      #   Symbol key will be converted to KeyWord.
      # @return [Object] Value.
      def [](key)
        key = KeyWord.new(key) if key.is_a?(Symbol)
        @hash[key]
      end

      # Store a pair of key and value.
      # @param [Object] key Key.
      #   Symbol key will be converted to KeyWord.
      # @param [Object] value Value.
      #   Symbol value will be converted to KeyWord.
      def []=(key, value)
        key = KeyWord.new(key) if key.is_a?(Symbol)
        value = KeyWord.new(value) if value.is_a?(Symbol)
        @hash[key] = value
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        return 'PDF:{}' if @hash.empty?

        joined = @hash.map do |k, v|
          k.to_s.concat('=>', v.to_s)
        end.join(', ')
        String.new('PDF:{').concat(joined, '}')
      end

      # Detailed description of this object.
      # @return [String] Description.
      def inspect
        String.new('#<').concat(
          self.class.name, ':',
          object_id.to_s, ' ', to_s, '>'
        )
      end

      # Render to string.
      # @return [String] Content.
      def render
        return '<< >>' if @hash.empty?

        result = String.new('<<' + LF)
        @hash.each do |k, v|
          key = Dopp::Util.pdf_type?(k) ? k.render : k.to_s
          value = Dopp::Util.pdf_type?(v) ? v.render : v.to_s
          result.concat(key, ' ', value, LF)
        end
        result.concat('>>')
      end
    end
  end
end
