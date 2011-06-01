# -*- encoding: UTF-8 -*-

require 'rubygems'
require 'time'
gem 'twitter4r'
require 'twitter'
class DashboardController < ApplicationController
  @@css_members = "@dai___chi @monja415 @hamhei "
  @@juiz_url = "http://hamhei.com/juiz"

  def overview
    get_tweet
    @requests = Request.find(:all, :order => 'tweet_datetime DESC')
  end


  def noblesse_oblige
    client = client_init
    tweet = "@" + params["request_user"] + " "  + params["tweet"] + @@css_members
    client.status(:post, tweet)
    req = Request.find(params["request_id"])
    req.tweet_url = tweet
    req.save
    redirect_to juiz_path
  end

  private
  def get_tweet
    client = client_init
    tweets = client.timeline_for(:replies)
    p tweets

    db_tweet = Request.find(:all, :order => 'tweet_datetime DESC').first
    recent_tweet_head = 0
    unless db_tweet.nil?
      tweets.each_with_index do |t, i|
        if t.id_str == db_tweet.tweet_id
	      recent_tweet_head = i
          break
        end
      end	
    else 
      recent_tweet_head = tweets.length
    end

	p recent_tweet_head
    if recent_tweet_head > 0
      tweets[0, recent_tweet_head].each do |t|
        req = Request.create(
                :tweet             => t.text,
                :tweet_id          => t.id_str,
                :profile_image_url => t.user.profile_image_url,
                :noblesse          => t.user.screen_name,
                :tweet_datetime    => t.created_at
              )
      end
      notify_str = @@css_members + "新しい依頼が届いてます。Noblesse Oblege. 今後もあなた樣方が仲睦まじい救世主であらんことを切に願います. " + @@juiz_url
      client.status(:post, notify_str)
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
