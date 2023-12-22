require_relative "helper"
require "deepmerge"

SingleCov.covered!

# most assertions compare by string because hashes don't care about order
describe DeepMerge do
  def test_array_shallow_merge
    vector = [1]
    assert_equal([1, 2], vector.deep_merge([2]))
    assert_equal([1], vector)
    vector.deep_merge!([2])
    assert_equal([1, 2], vector)
  end

  def test_hash_shallow_merge
    vector = {a:1}
    assert_equal({a:1, b:2}, vector.deep_merge({b:2}))
    assert_equal({a:1}, vector)
    vector.deep_merge!({b:2})
    assert_equal({a:1, b:2}, vector)
  end

  def test_array_in_hash
    vector = {a:1, b:[1,2]}
    assert_equal({a:1, b:[1,2,3]}, vector.deep_merge({b:[3]}))
    assert_equal({a:1, b:[1,2]}, vector)
    vector.deep_merge!({b:[3]})
    assert_equal({a:1, b:[1,2,3]}, vector)
  end

  def test_hash_in_array
    vector = [{a:1}, {b:2}, {a:3}]
    assert_equal([{a:1}, {b:2}, {a:3}, {c:4}], vector.deep_merge([{a:3}, {c:4}]))
    assert_equal([{a:1}, {b:2}, {a:3}], vector)
    vector.deep_merge!([{a:3}, {c:4}])
    assert_equal([{a:1}, {b:2}, {a:3}, {c:4}], vector)
  end

  def test_nested_structure
    vector = {a:[1, {b:2}], c:{d:[3,4]}}
    assert_equal({a:[1, {b:2}, "b"], c:{d:[3,4,5], e:"hello"}}, vector.deep_merge({a:["b"], c:{d:[5], e:"hello"}}))
    assert_equal({a:[1, {b:2}], c:{d:[3,4]}}, vector)
    vector.deep_merge!({a:["b"], c:{d:[5], e:"hello"}})
    assert_equal({a:[1, {b:2}, "b"], c:{d:[3,4,5], e:"hello"}}, vector)
  end

  it "overrides on collision" do
    {a: 1}.deep_merge(a: 2).must_equal a: 2
    {a: 1}.deep_merge!(a: 2).must_equal a: 2
  end

  describe "Object#deep_merge" do
    it "merges deeply" do
      vector = {a:[1,2], b:3}
      result = deep_merge(vector, {a:[3], c:4})
      result.must_equal({a:[1,2,3], b:3, c:4})
      vector.must_equal({a:[1,2], b:3})
    end

    it "does not merge when deep_merge is not available" do
      deep_merge(1, 1).must_equal 1
    end
  end

  describe "Object#deep_merge!" do
    it "merges deeply" do
      vector = {a:[1,2], b:3}
      result = deep_merge!(vector, {a:[3], c:4})
      result.must_equal({a:[1,2,3], b:3, c:4})
      vector.must_equal(result)
    end

    it "does not merge when deep_merge is not available" do
      deep_merge!(1, 1).must_equal 1
    end
  end
end
