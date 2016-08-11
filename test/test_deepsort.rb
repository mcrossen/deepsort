require "minitest/autorun"
require "deepsort"

# much of the assertions are compared by string. this is because hash comparisons don't care about order - string comparisons do
class TestDeepSort < MiniTest::Unit::TestCase

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
    assert_equal({1=>2, 3=>4}, vector)
  end

  def test_hash_in_array
    vector = [{7=>8, 5=>6}, {3=>4, 1=>2}]
    # hashes don't have a comparison operator <=> defined
    assert_equal([{1=>2, 3=>4}, {5=>6, 7=>8}].to_s, vector.deep_sort_by {|obj| obj.to_s}.to_s)
    # ensure it didn't sort in place
    assert_equal([{7=>8, 5=>6}, {3=>4, 1=>2}].to_s, vector.to_s)
    # now sort in place and vector
    vector.deep_sort_by! {|obj| obj.to_s}
    assert_equal([{1=>2, 3=>4}, {5=>6, 7=>8}], vector)
  end

  def test_array_in_hash
    vector = {4=>5, 1=>[3, 2]}
    assert_equal({1=>[2, 3], 4=>5}.to_s, vector.deep_sort.to_s)
    assert_equal({1=>[2, 3], 4=>5}, vector.deep_sort_by {|obj| obj.to_s})
    # ensure it didn't sort in place
    assert_equal({4=>5, 1=>[3, 2]}.to_s, vector.to_s)
    # now sort in place and vector
    vector.deep_sort!
    assert_equal({1=>[2, 3], 4=>5}, vector)
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
    assert_equal(sorted, vector)
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
    assert_equal({"a"=>["b", "c"], "d"=>"e"}, vector1)
    assert_equal([["a", "b"], ["c", "d"]], vector2)
  end
end
