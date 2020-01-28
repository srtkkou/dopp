# frozen_string_literal: false
require 'test_helper'

class UtilTest < Minitest::Test
  def test_OK_deep_freeze_array_and_hash
    obj = [{a: '1', 'b' => "2", c: [3, 4, {d: '5'}]}, 6]
    assert(!obj.frozen?)
    assert(!obj[0].frozen?)
    assert(!obj[0][:a].frozen?)
    assert(!obj[0]['b'].frozen?)
    assert(!obj[0][:c].frozen?)
    assert(!obj[0][:c][2].frozen?)
    assert(!obj[0][:c][2][:d].frozen?)
    Dopp::Util.deep_freeze(obj)
    assert(obj.frozen?)
    assert(obj[0].frozen?)
    assert(obj[0][:a].frozen?)
    assert(obj[0]['b'].frozen?)
    assert(obj[0][:c].frozen?)
    assert(obj[0][:c][2].frozen?)
    assert(obj[0][:c][2][:d].frozen?)
  end
end

