require_relative "helper"
require "deepsort"

SingleCov.covered!

# much of the assertions are compared by string. this is because hash comparisons don't care about order - string comparisons do
describe DeepSort do
  def test_shallow_sort_array
    vector = [3, 2, 1]
    assert_equal([1, 2, 3], vector.deep_sort)
    # ensure it didn't sort in place
    assert_equal([3, 2, 1], vector)
    # now sort in place and vector
    vector.deep_sort!
    assert_equal([1, 2, 3], vector)
  end

  def test_shallow_sort_hash
    vector = {3=>4, 1=>2}
    assert_equal({1=>2, 3=>4}.to_s, vector.deep_sort.to_s)
    # ensure it didn't sort in place
    assert_equal({3=>4, 1=>2}.to_s, vector.to_s)
    # now sort in place and vector
    vector.deep_sort!
    assert_equal({1=>2, 3=>4}.to_s, vector.to_s)
  end

  def test_hash_in_array
    vector = [{7=>8, 5=>6}, {3=>4, 1=>2}]
    # hashes don't have a comparison operator <=> defined
    assert_equal([{1=>2, 3=>4}, {5=>6, 7=>8}].to_s, vector.deep_sort_by {|obj| obj.to_s}.to_s)
    # ensure it didn't sort in place
    assert_equal([{7=>8, 5=>6}, {3=>4, 1=>2}].to_s, vector.to_s)
    # now sort in place and vector
    vector.deep_sort_by! {|obj| obj.to_s}
    assert_equal([{1=>2, 3=>4}, {5=>6, 7=>8}].to_s, vector.to_s)
  end

  def test_array_in_hash
    vector = {4=>5, 1=>[3, 2]}
    assert_equal({1=>[2, 3], 4=>5}.to_s, vector.deep_sort.to_s)
    assert_equal({1=>[2, 3], 4=>5}, vector.deep_sort_by {|obj| obj.to_s})
    # ensure it didn't sort in place
    assert_equal({4=>5, 1=>[3, 2]}.to_s, vector.to_s)
    # now sort in place and vector
    vector.deep_sort!
    assert_equal({1=>[2, 3], 4=>5}.to_s, vector.to_s)
  end

  def test_big_structure
    initial  = {1=>2, 9=>[10, 12, 11], 3=>{6=>[8, 7], 4=>5}}
    sorted   = {1=>2, 3=>{4=>5, 6=>[7, 8]}, 9=>[10, 11, 12]}
    vector = initial
    assert_equal(sorted.to_s, vector.deep_sort.to_s)
    # ensure it didn't sort in place
    assert_equal(initial.to_s, vector.to_s)
    # now sort in place and vector
    vector.deep_sort!
    assert_equal(sorted.to_s, vector.to_s)
  end

  def test_non_fixnum
    vector1 = {"d"=>"e", "a"=>["c", "b"]}
    vector2 = [["d", "c"], ["a", "b"]]
    assert_equal({"a"=>["b", "c"], "d"=>"e"}.to_s, vector1.deep_sort.to_s)
    assert_equal([["a", "b"], ["c", "d"]].to_s, vector2.deep_sort.to_s)
    assert_equal({"d"=>"e", "a"=>["c", "b"]}.to_s, vector1.to_s)
    assert_equal([["d", "c"], ["a", "b"]].to_s, vector2.to_s)
    vector1.deep_sort!
    vector2.deep_sort!
    assert_equal({"a"=>["b", "c"], "d"=>"e"}.to_s, vector1.to_s)
    assert_equal([["a", "b"], ["c", "d"]].to_s, vector2.to_s)
  end

  def test_hash_comparison
    assert_equal(0, {} <=> Hash.new)
    assert_equal(-1, {1=>2} <=> {2=>3})
    assert_equal(1, {2=>3} <=> {1=>2})
  end

  describe "#deep_sort_by" do
    it "sorts by given block" do
      original = {a: [1, 2], [1, 2] => :a}
      result = original.deep_sort_by { |x| x.is_a?(Array) ? 1 : -x }
      result.must_equal a: [2, 1], [2, 1] => :a
      original.must_equal a: [1, 2], [1, 2] => :a
    end
  end

  describe "#deep_sort_by!" do
    it "replaces with sorted by given block" do
      original = {a: [1, 2], [1, 2] => :a}
      result = original.deep_sort_by! { |x| x.is_a?(Array) ? 1 : -x }
      original.must_equal a: [2, 1], [2, 1] => :a
      original.object_id.must_equal result.object_id
    end
  end

  describe "Object#deep_sort" do
    it "sorts deeply" do
      original = [["a"], ["b", "a"]]
      result = deep_sort(original)
      result.must_equal [["a"], ["a", "b"]]
      original.must_equal [["a"], ["b", "a"]]
    end

    it "sorts normally when deep is not available" do
      fake = Class.new { define_method(:sort) { 1 } }.new
      deep_sort(fake).must_equal 1
    end

    it "does not sort when sort is not available" do
      deep_sort(1).must_equal 1
    end
  end

  describe "Object#deep_sort" do
    it "sorts deeply" do
      original = [["a"], ["b", "a"]]
      deep_sort!(original)
      original.must_equal [["a"], ["a", "b"]]
    end

    it "sorts normally when deep is not available" do
      fake = Class.new { define_method(:sort!) { 1 } }.new
      deep_sort!(fake).must_equal 1
    end

    it "does not sort when sort is not available" do
      deep_sort!(1).must_equal 1
    end
  end
end
