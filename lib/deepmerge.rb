### Deep Merge Utility
## Over View
# when included into a project, this utility gives Arrays and Hashes the ability to deeply merge with other arrays and hashes
# instead of shallow merges, deep_merge recursively merges each nested array and hash.
# this does mean that the hashes and arrays must have similar structures.

module DeepMerge
  # inject this method into the Array class to add deep merging functionality to Arrays
  module DeepMergeArray
    def deep_merge(other)
      concat(other).uniq
    end
  end

  # inject this method into the Hash class to add deep merge functionality to Hashes
  module DeepMergeHash
    def deep_merge(other)
      merge(other) do |key, oldval, newval|
        if oldval.respond_to? :deep_merge
          oldval.deep_merge(newval)
        else
          newval
        end
      end
    end
  end
end

Array.send(:include, DeepMerge::DeepMergeArray)
Hash.send(:include, DeepMerge::DeepMergeHash)
