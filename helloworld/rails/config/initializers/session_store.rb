# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_IronRubyOnRails_session',
  :secret      => 'ece65a60575668fac5d1823abae57a974e41d0a6c5374739cd3b6b718198fa10b8929382bc0643c91a6f100f933ba5ae446c7c6f039b2346271db4f5f0e78625'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
