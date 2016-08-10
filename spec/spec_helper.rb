require 'simplecov'

SimpleCov.start('rails') do
  merge_timeout 7200
  coverage_dir ENV['COVERAGE_DIR'] || 'coverage/rspec'
end


RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
