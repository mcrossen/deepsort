# deepsort

[![Gem Version](https://img.shields.io/gem/v/deepsort.svg?&color=brightgreen)](https://rubygems.org/gems/deepsort)
[![Build Status](https://github.com/mcrossen/deepsort/workflows/Ruby/badge.svg)](https://github.com/mcrossen/deepsort/workflows/Ruby.yml)
[![Coverage](https://img.shields.io/badge/coverage-100%25-success.svg)](https://github.com/grosser/single_cov)

'deepsort' is a ruby gem that adds the methods you've always wanted to arrays and hashes. The next time you need to sort or merge an array inside of a hash inside of an array, deepsort makes that as easy as calling .deep_sort or .deep_merge on the object.

## Installation

To install deepsort, use the following terminal command:
```bash
gem install deepsort
```

### Deep Sorting

To add deep sorting functionality to arrays and hashes, include it in your project like so:
```ruby
require "deepsort"
```

To deeply sort an array or hash without changing the object itself, use the 'deep_sort' method.
```ruby
require "deepsort"

nested = {"b" => 3, "a"=>[2, 1]}
puts nested.deep_sort
# => {"a" => [1, 2], "b" => 3}
```

To deeply sort an array or hash in place, use the deep_sort! method.
```ruby
require "deepsort"

nested = {"b" => 3, "a"=>[2, 1]}
nested.deep_sort!
puts nested
# => {"a" => [1, 2], "b" => 3}
```

Compare objects by string when deepsorting with the deep_sort_by or deep_sort_by! methods. This is useful to ignore errors from arrays not being able to compare with hashes.
```ruby
require "deepsort"

puts [{"c" => [2, 1]}, ["b", "a"]].deep_sort_by {|obj| obj.to_s}
# => [["a", "b"], {"c" => [1, 2]}]
```

Skip arrays or hashs sorting.
```ruby
require "deepsort"

puts {"b" => [2, 1], "a" => [4, 3]}.deep_sort(array: false)
# => {"a" => [4, 3], "b" => [2, 1]}

puts {"b" => [2, 1], "a" => [4, 3]}.deep_sort(hash: false)
# => {"b" => [1, 2], "a" => [3, 4]}
```

### Deep Merging

The deepsort gem also includes deep merging capabilities. This concatenates arrays and merges hashes in large nested structures. To add deep merging functionality to arrays and hashes, include it in your project like so:
```ruby
require "deepmerge"
```

Using deepmerge is similar to deepsort. The biggest difference is that the structure to be merged with is passed in as an argument.
```ruby
require "deepmerge"

nested = {"a" => [1, 2], "b" => 3}
puts nested.deep_merge({"a" => [3], "c" => 4})
# => {"a"=>[1, 2, 3], "b"=>3, "c"=>4}
```

To deeply merge a structure in place, use the deep_merge! method instead.
