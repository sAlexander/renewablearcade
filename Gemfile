source 'https://rubygems.org'
ruby '2.0.0'

gem 'sinatra', '1.4.4'
gem 'haml', '4.0.4'
gem 'sequel', '4.4.0'
gem 'sinatra-sequel'
gem 'sqlite3'
gem 'unicorn'

group :development, :test do
  gem 'rspec', '2.14.1'

  # guard gems
  gem 'guard', '2.2.4'
  gem 'guard-rspec', '4.0.4'
  gem 'guard-shotgun', :git => 'https://github.com/rchampourlier/guard-shotgun.git'

  # spork gems
  gem 'guard-spork', '1.5.1'
  gem 'spork', '0.9.2'
end

group :test do
  gem 'capybara', '2.1.0'

  ###### System-dependent gems goes below here
  ### Test gems on Macintosh OS X
  # gem 'rb-fsevent', '0.9.1', :require => false
  # gem 'growl', '1.0.3'

  ### Test gems on Linux
  gem 'rb-inotify', '0.9.2'
  gem 'libnotify', '0.8.2'

  ### Test gems on Windows
  # gem 'rb-fchange', '0.0.5'
  # gem 'rb-notifu', '0.0.4'
  # gem 'win32console', '1.3.0'
end
