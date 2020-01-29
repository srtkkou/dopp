# frozen_string_literal: true
module Dopp
  module Type
    class Name
      # Initialize.
      def initialize(name)
        raise(ArgumentError) unless
          [String, Symbol].include?(name.class)
        @content = "/#{name}".freeze
      end

      # Hash value of this object.
      # @return [Integer] Hash value of this object.
      def hash
        @content.hash
      end

      # Compare as a key of hash.
      # @param other [Other] Other object.
      # @return [Bool] true=equal, false=not equal.
      def eql?(other)
        return false unless
          other.instance_of?(self.class)
        (@content.hash == other.hash)
      end

      # Rendered content.
      # @return [String] Content.
      def render
        @content
      end
    end
  end
end

