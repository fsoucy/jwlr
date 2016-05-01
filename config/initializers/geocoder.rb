Geocoder.configure(
:timeout => 30,
:ip_lookup => :google,
:cache => KeyStore.new
)
