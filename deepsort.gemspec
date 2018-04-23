Gem::Specification.new do |s|
  s.name        = 'deepsort'
  s.version     = '0.4.1'
  s.date        = '2018-04-22'
  s.summary     = 'A utility to deep sort arrays and hashes.'
  s.description = 'deepsort recursively sorts nested ruby Arrays and Hashes.'
  s.authors     = ["Mark Crossen"]
  s.email       = 'markcrossen@studentbody.byu.edu'
  s.files       = ["lib/deepsort.rb", "lib/deepmerge.rb"]
  s.homepage    = 'https://github.com/mcrossen/deepsort'
  s.license     = 'MIT'
  s.required_ruby_version = '> 1.8.7'
end
