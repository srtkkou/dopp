# frozen_string_literal: true
require 'test_helper'
require 'dopp/type/time_stamp'

module Dopp
  module Type
    class TimeStampTest < Minitest::Test
      def test_OK_initialize
        assert_raises(ArgumentError){TimeStamp.new}
        assert_raises(ArgumentError){TimeStamp.new('2020/01/02 15:31:21')}
        assert_raises(ArgumentError){TimeStamp.new(1)}
        assert_raises(ArgumentError){TimeStamp.new(3.14)}
        assert_raises(ArgumentError){TimeStamp.new(['a', 'b'])}
        assert_raises(ArgumentError){TimeStamp.new({a: :b})}
        assert("(D:20060102150405+09'00')",
          TimeStamp.new(Time.new(2006, 1, 2, 15, 4, 5, '+09:00')).to_s)
      end
    end
  end
end

