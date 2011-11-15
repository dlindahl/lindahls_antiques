ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

# In-memory SQLite Rails testing
# From http://www.osmonov.com/2011/01/in-memory-sqlite-database-for-testing.html
load_schema = lambda { load "#{Rails.root}/db/schema.rb" }
silence_stream(STDOUT, &load_schema)

require 'rails/test_help'

# require 'test_notifier/runner/test_unit'

# TestNotifier.default_notifier = :growl

require 'machinist/active_record'
require File.dirname(__FILE__) + '/blueprints'

class ActiveSupport::TestCase
  setup do
    Sham.reset

    user = Fleakr::Objects::User.new
    user.id = "26474870@N03" # from ENV['FLICKR_USERNAME']
    Fleakr.stubs(:user).returns( user )
  end
end

# This should allow Travis-CI to run the tests without setting Flickr API keys.
# This *will*, however, make adding new FlickrAPI calls through VCR a bit tricky
# since this will generate invalid API URIs.
class Fleakr::Api::ParameterList
  def authentication_token
    "123"
  end
  def default_options
    { :api_key => "123" }
  end
  def signature
    "123"
  end
end

VCR.config do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.stub_with :fakeweb
end
