class Message < ActiveRecord::Base
  TWITTER_CONFIG = YAML.load_file("#{::Rails.root}/config/twitter.yml")[::Rails.env]
  attr_accessor :custom

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :my_process

  after_create :send_twitter_update

  
  def send_twitter_update
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_CONFIG['key']
      config.consumer_secret     = TWITTER_CONFIG['secret']
      config.access_token        = sender.token
      config.access_token_secret = sender.secret
    end
    if custom
      client.update(message)
    else
      client.update("@#{receiver.username} ##{my_process.hashtag} #{message}")
    end
  end
end
