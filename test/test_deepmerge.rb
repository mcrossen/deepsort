require "minitest/autorun"
require "deepmerge"

# much of the assertions are compared by string. this is because hash comparisons don't care about order - string comparisons do
class TestDeepMerge < MiniTest::Unit::TestCase
  def test_shallow_merge
    vector = {a:1}.deep_merge({b:2})
    assert_equal({a:1, b:2}, vector)
  end

  def test_array_in_hash
    vector = {a:1, b:[1,2]}.deep_merge({b:[3]})
    assert_equal({a:1, b:[1,2,3]}, vector)
  end

  def test_hash_in_array
    vector = [{a:1}, {b:2}, {a:3}].deep_merge([{a:3}, {c:4}])
    assert_equal([{a:1}, {b:2}, {a:3}, {c:4}], vector)
  end

  def test_large_structure
    vector = {a:[1, {b:2}], c:{d:[3,4]}}.deep_merge({a:["b"], c:{d:[5], e:"hello"}})
    assert_equal({a:[1, {b:2}, "b"], c:{d:[3,4,5], e:"hello"}}, vector)
  end
end
