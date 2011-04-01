# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_findyourhouse_session',
  :secret      => '99aa10d13918c4aca00b4a923235d2b9ebd8358ab548a6fa01a757a039b733f7b4682bdf80f9e11aa4960bf3d180c2f04dc212d1fb17ad35a176cebddb48c792'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
