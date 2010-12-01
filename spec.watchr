require 'stringio'
require 'autowatchr'

Autowatchr.new(self) do |config|
  config.test_dir = 'spec'
  config.test_re = "^spec/.*_spec\\.rb$"
  config.test_file = '%s_spec.rb'
end
