require "bundler/setup"

require "single_cov"
SingleCov.setup :minitest

require "maxitest/autorun"

$LOAD_PATH << "lib"
