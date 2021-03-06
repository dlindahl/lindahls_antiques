source 'http://rubygems.org'

gem 'rake', '~> 0.9.2.2'
gem 'rails', '~> 3.1.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :production do
  gem 'pg'
end
group :development, :test do
  gem 'sqlite3', '~> 1.3.3'
end

gem 'devise', '~> 1.4.9'
gem 'fleakr', '~> 0.7.1'

gem "httparty", "0.8.1"
gem 'ebayapi', :git => "git://github.com/UGE-developer/ebay.git"
gem "ebay_api_wrapper", :path => "../ebay_api_wrapper"

gem 'formtastic', '~> 2.0.1'
gem 'rdiscount', '~> 1.6.8'
gem 'validates_timeliness', '~> 3.0.2'
gem 'state_machine', '~> 1.0.2'

gem 'activeadmin', '~> 0.3.2', :git => "git://github.com/gregbell/active_admin.git"
gem 'stache', '~> 0.1.0', :git => "git://github.com/dlindahl/stache.git"
gem 'http_status_exceptions', :git => 'git://github.com/dlindahl/http_status_exceptions.git'

group :development do
  gem 'heroku', '~> 2.13.0'
end

group :test do
  gem 'minitest',   '~> 2.8.0'
  gem 'purdytest',  '~> 1.0.0', :require => false
  gem 'machinist',  '~> 1.0.6'
  gem 'faker',      '~> 1.0.1'
  gem 'mocha',      '~> 0.10.0', :require => false
  # gem 'shoulda', '~> 2.11.3'
  gem 'shoulda',    :git => 'https://github.com/thoughtbot/shoulda.git'
  # gem 'autotest', '~> 4.4.6'
  # gem 'autotest-rails', '~> 4.1.0'
  gem 'test_notifier', '~> 1.0.0'
  gem 'rcov',       '~> 0.9.9'
  gem 'vcr',        '~> 1.11.3'
  gem 'fakeweb',    '~> 1.3.0'
end

gem 'sass-rails', "~> 3.1.4"
gem 'compass', :git => 'git://github.com/chriseppstein/compass.git'
group :assets do
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier', '~> 1.0.4'
end