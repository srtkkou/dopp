# frozen_string_literal: true

module Dopp
  module Type
    # PDF type "Name".
    class KeyWord
      # Initialize.
      # @param [String|Symbol] name Name.
      def initialize(name)
        raise(ArgumentError) unless
          name.is_a?(String) || name.is_a?(Symbol)
        @sym = "/#{name}".to_sym
      end

      # Calculate hash.
      # @return [Integer] Hash.
      def hash
        @sym.hash
      end

      # Compare with other object.
      # @param [Object] other Other object.
      # @return [Bool] True=same, false=different.
      def eql?(other)
        return false unless
          other.instance_of?(self.class)
        self.hash == other.hash
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        String.new('PDF:').concat(@sym.to_s)
      end

      # Detailed description of this object.
      # @return [String] Description.
      def inspect
        String.new('#<').concat(
          self.class.name, ':',
          object_id.to_s, ' ', self.to_s, '>'
        )
      end

      # Render to string.
      # @return [String] Content.
      def render
        @sym.to_s
      end
    end
  end
end
