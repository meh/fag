# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fag_session',
  :secret      => '50808d312f1510a5a48600560625630f7d682be86f7d90db084ece2082d1ff98c39ce7a4e4832c41638cef759dc89f5cc469c294c8002fbf9844317b02fbaf82'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
