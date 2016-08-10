require "minitest/autorun"
require "deepsort"

class TestDeepSort < MiniTest::Unit::TestCase

  def test_shallow_sort_array
    vector = [3, 2, 1]
    assert_equal(vector.deep_sort, [1, 2, 3])
    # ensure it didn't sort in place
    assert_equal(vector, [3, 2, 1])
    # now sort in place and vector
    vector.deep_sort!
    assert_equal(vector, [1, 2, 3])
  end

  def test_shallow_sort_hash
    vector = {3=>4, 1=>2}
    assert_equal(vector.deep_sort, {1=>2, 3=>4})
    # ensure it didn't sort in place
    assert_equal(vector, {3=>4, 1=>2})
    # now sort in place and vector
    vector.deep_sort!
    # sorting in place doesn't sort hash keys
    assert_equal(vector, {3=>4, 1=>2})
  end

  def test_hash_in_array
    vector = [{7=>8, 5=>6}, {3=>4, 1=>2}]
    # hashes don't have a comparison operator <=> defined
    assert_equal(vector.deep_sort_by {|obj| obj.to_s}, [{1=>2, 3=>4}, {5=>6, 7=>8}])
    # ensure it didn't sort in place
    assert_equal(vector, [{7=>8, 5=>6}, {3=>4, 1=>2}])
    # now sort in place and vector
    vector.deep_sort_by! {|obj| obj.to_s}
    # sorting in place doesn't sort hash keys
    assert_equal(vector, [{3=>4, 1=>2}, {7=>8, 5=>6}])
  end

  def test_array_in_hash
    vector = {4=>5, 1=>[3, 2]}
    assert_equal(vector.deep_sort, {1=>[2, 3], 4=>5})
    assert_equal(vector.deep_sort_by {|obj| obj.to_s}, {1=>[2, 3], 4=>5})
    # ensure it didn't sort in place
    assert_equal(vector, {4=>5, 1=>[3, 2]})
    # now sort in place and vector
    vector.deep_sort!
    # sorting in place doesn't sort hash keys
    assert_equal(vector, {4=>5, 1=>[2,3]})
  end

  def test_big_structure
    initial  = {1=>2, 9=>[10, 12, 11], 3=>{6=>[8, 7], 4=>5}}
    sorted   = {1=>2, 3=>{4=>5, 6=>[7, 8]}, 9=>[10, 11, 12]}
    in_place = {1=>2, 9=>[10, 11, 12], 3=>{6=>[7, 8], 4=>5}}
    vector = initial
    assert_equal(vector.deep_sort, sorted)
    # ensure it didn't sort in place
    assert_equal(vector, initial)
    # now sort in place and vector
    vector.deep_sort!
    # sorting in place doesn't sort hash keys
    assert_equal(vector, in_place)
  end

  def test_non_fixnum
    vector1 = {"d"=>"e", "a"=>["c", "b"]}
    vector2 = [["d", "c"], ["a", "b"]]
    assert_equal(vector1.deep_sort, {"a"=>["b", "c"], "d"=>"e"})
    assert_equal(vector2.deep_sort, [["a", "b"], ["c", "d"]])
    assert_equal(vector1, {"d"=>"e", "a"=>["c", "b"]})
    assert_equal(vector2, [["d", "c"], ["a", "b"]])
    vector1.deep_sort!
    vector2.deep_sort!
    assert_equal(vector1, {"d"=>"e", "a"=>["b", "c"]})
    assert_equal(vector2, [["a", "b"], ["c", "d"]])
  end
end
