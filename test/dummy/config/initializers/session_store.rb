# Be sure to restart your server when you modify this file.

session_store = {
  key:    '_dummy_session',
  domain: 'localhost'
}

if Rails.env.test?
  session_store[:domain] = ENV['APP_DOMAIN_TEST']
elsif Rails.env.development?
  session_store[:domain] = ENV['APP_DOMAIN_DEVELOPMENT']
end

Rails.application.config.session_store :cookie_store, session_store
