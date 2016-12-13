class TestsController < ApplicationController
  TWITTER_CONFIG = YAML.load_file("#{::Rails.root}/config/twitter.yml")[::Rails.env]
  
  def index
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_CONFIG['key']
      config.consumer_secret     = TWITTER_CONFIG['secret']
      config.access_token        = current_user.token
      config.access_token_secret = current_user.secret
    end
    render text: client.update('lorem ipsum')
    return
  end
end



