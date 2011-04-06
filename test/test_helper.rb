ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'machinist/active_record'
require File.dirname(__FILE__) + '/blueprints'

class ActiveSupport::TestCase
  setup { Sham.reset }
end
