require 'rubygems'
require 'time'
gem 'twitter4r'
require 'twitter'
class DashboardController < ApplicationController

  def overview
    get_tweet
    @requests = Request.find(:all, :order => 'id DESC')
  end


  def noblesse_oblige
    client = client_init
    css_members = "@monja415 @dai___chi @hamhei "
    tweet = "@" + params["request_user"] + " "  + params["tweet"] + css_members
    client.status(:post, tweet)
    req = Request.find(params["request_id"])
    req.tweet_url = tweet
    req.save
    redirect_to juiz_path
  end

  private
  def get_tweet
    client = client_init
    tweets = client.timeline_for(:replies).reverse
    p tweets
    db_tweet = Request.last
    recent_tweet_id = 0
    unless db_tweet.nil?
      tweets.each_with_index do |t, i|
        if t.id_str.to_i == db_tweet.tweet_id
          recent_tweet_id = i + 1
          break
        end
      end
    end
    if recent_tweet_id <= tweets.length
      tweets[recent_tweet_id, tweets.length].each do |t|
        Request.create(
          :tweet             => t.text,
          :tweet_id          => t.id_str.to_i,
          :profile_image_url => t.user.profile_image_url,
          :noblesse          => t.user.screen_name,
          :tweet_datetime    => t.created_at
        )
      end
    end
   # redirect_to juiz_overview_path
  end

  def client_init
    Twitter::Client.configure do |conf|
      conf.oauth_consumer_token = Rails.application.config.base['platforms']['twitter']['consumer_key']
      conf.oauth_consumer_secret = Rails.application.config.base['platforms']['twitter']['consumer_secret']
    end

    client = Twitter::Client.new(
                :oauth_access =>{
                  :key => Rails.application.config.base['platforms']['twitter']['access_token'],
                  :secret => Rails.application.config.base['platforms']['twitter']['access_token_secret']
             })
    return client
  end

end
