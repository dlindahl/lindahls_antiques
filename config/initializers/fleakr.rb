unless Rails.env.test?
  Fleakr.api_key = ENV['FLICKR_API_KEY']
  Fleakr.shared_secret = ENV['FLICKER_SHARED_SECRET']
  Fleakr.auth_token = ENV['FLICKR_AUTH_TOKEN']
end