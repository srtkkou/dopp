# frozen_string_literal: true
require 'forwardable'
require 'dopp/util'

module Dopp
  module Type
    # PDF type "Dictionary".
    class Dictionary
      extend Forwardable

      # Delegate methods of Hash.
      def_delegators :@hash, *(%i[
        [] []= store each empty?
        has_key? key? include? member?
        has_value? value?
        keys length size merge! update
      ])

      # Initialize.
      # @param [Hash] hash Hash argument.
      def initialize(hash = {})
        raise(ArgumentError) unless hash.is_a?(Hash)
        @hash = hash
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        return 'PDF:{}' if @hash.empty?
        # When the hash is not empty.
        joined = @hash.map{|k, v|
          k.to_s.concat('=>', v.to_s)
        }.join(', ')
        String.new('PDF:{').concat(joined, '}')
      end

      # Detailed description of this object.
      # @return [String] Description.
      def inspect
        String.new('#<').concat(self.class.name, ':',
          self.object_id.to_s, ' ', self.to_s, '>')
      end

      # Render to string.
      # @return [String] Content.
      def render
        return '<< >>' if @hash.empty?
        # When the hash is not empty
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

