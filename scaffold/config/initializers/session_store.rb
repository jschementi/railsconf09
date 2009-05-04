# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_IronRubyOnRails_session',
  :secret      => '9f396e55c7db01656fa2f6e042c51e9b82d8d3cbbb7b3987a7b34f3b122afbeeac8d8a0a6eaab538ee25a401564c16b8ba5fd46b03c7c809aa4e883b456139ed'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
