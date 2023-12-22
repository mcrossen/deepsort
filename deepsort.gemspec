Gem::Specification.new 'deepsort', '0.5.0' do |s|
  s.summary     = 'A utility to deep sort arrays and hashes.'
  s.description = 'Recursively sort nested ruby Arrays and Hashes + deepmerge'
  s.authors     = ["Mark Crossen"]
  s.email       = 'markcrossen@studentbody.byu.edu'
  s.files       = `git ls-files lib LICENSE`.split("\n")
  s.homepage    = 'https://github.com/mcrossen/deepsort'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.3.0'
end
