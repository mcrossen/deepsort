### Deep Sort Utility
## Over View
# when included into a project, this utility gives Arrays and Hashes the ability to deep sort themselves
# instead of shallow sorts, deep_sort recursively attempts to sort every element of arrays and hashes
## Usage
# {2=>4, 1=>[3, 2]}.deep_sort
#   returns: {1=>[2, 3], 2=>4}
# [{2=>3}, 1].deep_sort
#   returns an error because a Fixnum (1) cannot be compared with a Hash ({2=>3})
# [{2=>3}, 1].deep_sort_by {|obj| obj.to_s}
#   returns: [1, {2=>3}] # this avoids the error by using string comparison
# foo = [2, 1]; foo.deep_sort!
#   returns: [1, 2] # in addition foo has now been sorted in place


module DeepSort
  # inject this method into the Array class to add deep sort functionality to Arrays
  module DeepSortArray
    def deep_sort(options = {})
      deep_sort_by(options) { |obj| obj }
    end

    def deep_sort!(options = {})
      deep_sort_by!(options) { |obj| obj }
    end

    def deep_sort_by(options = {}, &block)
      array = self.map do |value|
        if value.respond_to?(:deep_sort_by)
          value.deep_sort_by(options, &block)
        else
          value
        end
      end
      options[:array] == false ? array : array.sort_by(&block)
    end

    def deep_sort_by!(options = {}, &block)
      array = self.map! do |value|
        if value.respond_to?(:deep_sort_by!)
          value.deep_sort_by!(options, &block)
        else
          value
        end
      end
      options[:array] == false ? array : array.sort_by!(&block)
    end
  end

  # inject this method into the Hash class to add deep sort functionality to Hashes
  module DeepSortHash
    def deep_sort(options = {})
      deep_sort_by(options) { |obj| obj }
    end

    def deep_sort!(options = {})
      deep_sort_by!(options) { |obj| obj }
    end

    def deep_sort_by(options = {}, &block)
      hash = self.map do |key, value|
        [if key.respond_to?(:deep_sort_by)
          key.deep_sort_by(options, &block)
        else
          key
        end,

        if value.respond_to?(:deep_sort_by)
          value.deep_sort_by(options, &block)
        else
          value
        end]
      end

      Hash[options[:hash] == false ? hash : hash.sort_by(&block)]
    end

    def deep_sort_by!(options = {}, &block)
      hash = self.map do |key, value|
        [if key.respond_to?(:deep_sort_by!)
          key.deep_sort_by!(options, &block)
        else
          key
        end,

        if value.respond_to?(:deep_sort_by!)
          value.deep_sort_by!(options, &block)
        else
          value
        end]
      end
      replace(Hash[options[:hash] == false ? hash : hash.sort_by!(&block)])
    end

    # comparison for hashes is ill-defined. this performs array or string comparison if the normal comparison fails.
    def <=>(other)
      super(other) || to_a <=> other.to_a || to_s <=> other.to_s
    end
  end
end
Array.send(:include, DeepSort::DeepSortArray)
Hash.send(:include, DeepSort::DeepSortHash)


# and if you don't like calling member methods on objects, these two functions do it for you.
# if the object cannot be deep sorted, it will simply return the sorted object or the object itself if sorting isn't available.
def deep_sort(obj, options = {})
  if obj.respond_to? :deep_sort
    obj.deep_sort(options)
  elsif obj.respond_to? :sort
    obj.sort
  else
    obj
  end
end

# similar to the deep_sort method, but performs the deep sort in place
def deep_sort!(obj, options = {})
  if obj.respond_to? :deep_sort!
    obj.deep_sort!(options)
  elsif obj.respond_to? :sort!
    obj.sort!
  else
    obj
  end
end
