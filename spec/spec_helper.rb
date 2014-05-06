ENV['TEST'] = '1'

if RUBY_VERSION != "1.8.7"
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "pp"
 
root = File.expand_path('../../', __FILE__)
require "#{root}/lib/text_injector"