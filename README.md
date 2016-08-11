# deepsort

[![Build Status](https://travis-ci.org/mcrossen/deepsort.svg?branch=master)](https://travis-ci.org/mcrossen/deepsort)

'deepsort' is a ruby gem that adds the methods you've always wanted to Arrays and Hashes. The next time you need to sort an array inside of a hash inside of an array, deepsort makes that as easy as calling .deepsort on the object.

## Installation

to install deepsort,
```bash
gem install deepsort
```

## Usage

to use deepsort, include it in your project like so:
```ruby
require "deepsort"
```

to deepsort an array or hash without changing the object itself, use the 'deep_sort' method
```ruby
require "deepsort"

nested = {"b" => 3, "a"=>[2, 1]}
puts nested.deep_sort
# => {"a" => [1, 2], "b" => 3}
```

to deepsort an array or hash in place, use the deep_sort! method
```ruby
require "deepsort"
nested = {"b" => 3, "a"=>[2, 1]}
nested.deep_sort!
puts nested
# => {"a" => [1, 2], "b" => 3}
```

compare objects by string when deepsorting with the deep_sort_by or deep_sort_by! methods. This is useful to ignore errors from arrays not being able to compare with hashes.
```ruby
require "deepsort"

puts [{"c" => [2, 1]}, ["b", "a"]].deep_sort_by {|obj| obj.to_s}
# => [["a", "b"], {"c" => [1, 2]}]
```
