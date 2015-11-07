source 'https://rubygems.org'

#gem 'puma'
gem 'rails',        '4.2.4'
gem 'sass-rails',   '5.0.4'
gem 'uglifier',     '2.7.2'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.5'
gem 'turbolinks',   '2.5.3'
gem 'jbuilder',     '2.3.2'
gem 'sdoc',         '0.4.1', group: :doc

group :development, :test do
  gem 'sqlite3',     '1.3.11'
  gem 'byebug',      '8.0.0'
  gem 'web-console', '2.2.1'
  gem 'spring',      '1.4.0'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

#Deploy without this
#$ bundle install --without production
group :production do
  gem 'pg',             '0.18.3'
  gem 'rails_12factor', '0.0.3'
end


ruby '2.2.3'