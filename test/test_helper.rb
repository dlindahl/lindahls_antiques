ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'test_notifier/runner/test_unit'

TestNotifier.default_notifier = :growl

require 'machinist/active_record'
require File.dirname(__FILE__) + '/blueprints'

class ActiveSupport::TestCase
  setup { Sham.reset }
end
