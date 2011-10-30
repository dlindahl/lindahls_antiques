ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

# In-memory SQLite Rails testing
# From http://www.osmonov.com/2011/01/in-memory-sqlite-database-for-testing.html
load_schema = lambda { load "#{Rails.root}/db/schema.rb" }
silence_stream(STDOUT, &load_schema)

require 'rails/test_help'

require 'test_notifier/runner/test_unit'

TestNotifier.default_notifier = :growl

require 'machinist/active_record'
require File.dirname(__FILE__) + '/blueprints'

class ActiveSupport::TestCase
  setup { Sham.reset }
end


VCR.config do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.stub_with :fakeweb
end
