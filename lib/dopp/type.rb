# frozen_string_literal: true
require 'dopp/type/name'
require 'dopp/type/text'
require 'dopp/type/hex_text'
require 'dopp/type/time_stamp'
require 'dopp/type/reference'
require 'dopp/type/list'
require 'dopp/type/dictionary'

module Dopp
  module Type
    module_function

    def name(name)
      Name.new(name)
    end

    def text(string)
      Text.new(string)
    end

    def time(time)
      TimeStamp.new(time)
    end

    def reference(id, revision)
      Reference.new(id, revision)
    end

    def list(array)
      List.new(array)
    end

    def dict(hash)
      Dictionary.new(hash)
    end

    def utf8_to_xtext(string)
      HexText.new_by_utf8(string)
    end
  end
end

