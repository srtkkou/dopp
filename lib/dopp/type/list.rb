# frozen_string_literal: true
require 'forwardable'

module Dopp
  module Type
    class List
      extend Forwardable

      # Delegate methods of Array.
      def_delegators :@content, *(%i[
        << [] at []= empty? length size
      ])

      # Initialize.
      # @params args [Array] Arguments.
      def initialize(*args)
        @content = args
      end

      # Rendered content.
      # @return [String] Content.
      def render
        return '[ ]' if @content.empty?
        '[' + @content.join(' ') + ']'
      end

=begin
      def inspect
        # 配列が空または10未満のサイズの場合
        return @content.render if
          @content.empty? || @content.size < 10
        # 配列長が10以上の場合
        head = @content[0, 10]
        tail = @content[10, @content.size]
        out = []
        out << "[ %s" % head.collect{|item| value_to_s(item)}.join(" ")
        #indent!
        tail.each_slice(LF_SIZE){|slice|
          out << space + slice.collect{|item| value_to_s(item)}.join(" ")
        }
        #outdent!
        out[out.size - 1] += " ]"
        out.join(Dopp::LF)
      end
=end
    end
  end
end

