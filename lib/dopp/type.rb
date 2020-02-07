# frozen_string_literal: true

require 'dopp/type/key_word'
require 'dopp/type/text'
require 'dopp/type/hex_text'
require 'dopp/type/time_stamp'
require 'dopp/type/reference'
require 'dopp/type/list'
require 'dopp/type/dictionary'

module Dopp
  # PDF type.
  module Type
    module_function

    # Initialize KeyWord.
    # @return [Dopp::Type::KeyWord] KeyWord.
    def kw(key)
      KeyWord.new(key)
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

    def xtext(array)
      HexText.new(array)
    end

    def utf8_to_xtext(string)
      HexText.new_by_utf8(string)
    end
  end
end
