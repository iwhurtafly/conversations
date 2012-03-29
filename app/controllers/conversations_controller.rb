class ConversationsController < ApplicationController
  require 'time'
  require 'rubygems'
  require 'hashie'
  require 'twitter'

  def new
    flash[:notice] = ""
  end
  
  def find
    begin
      user1 = Twitter.user(params[:search_string1])
      @user1 = Array.new
      @user1.push("#{user1['name']}", "#{user1['screen_name']}", "#{user1['location']}", "#{user1['description']}", "#{user1['url']}")
      @user1_img = Twitter.profile_image(params[:search_string1], :size => 'bigger')
      @user1_recent_tweet = Twitter.user_timeline(params[:search_string1]).first.text
    rescue Twitter::Error::NotFound
      flash[:notice] = 'We couldn\'t find that user1...'
    rescue Twitter::Error::BadGateway, Twitter::Error::BadRequest, Twitter::Error::EnhanceYourCalm, Twitter::Error::Forbidden, Twitter::Error::InternalServerError, Twitter::Error::NotAcceptable, Twitter::Error::ServiceUnavailable, Twitter::Error::Unauthorized
      flash[:notice] = 'Maybe Twitter is down...'
    end
    
    begin
      user2 = Twitter.user(params[:search_string2])
      @user2 = Array.new
      @user2.push("#{user2['name']}", "#{user2['screen_name']}", "#{user2['location']}", "#{user2['description']}", "#{user2['url']}")
      @user2_img = Twitter.profile_image(params[:search_string2], :size => 'bigger')
      @user2_recent_tweet = Twitter.user_timeline(params[:search_string2]).first.text
    rescue Twitter::Error::NotFound
      flash[:notice] = 'We couldn\'t find that user2...'
    rescue Twitter::Error::BadGateway, Twitter::Error::BadRequest, Twitter::Error::EnhanceYourCalm, Twitter::Error::Forbidden, Twitter::Error::InternalServerError, Twitter::Error::NotAcceptable, Twitter::Error::ServiceUnavailable, Twitter::Error::Unauthorized
      flash[:notice] = 'Maybe Twitter is down...'
    end
  end

  def show
    flash[:notice] = ""
    begin
      reply1 = Array.new
      
      i = 0
      #3200Tweets are MAX.
      how_many_tweets = params[:how_many_tweets].to_i ** 2
      how_many_tweets.times {
        i += 1
        Twitter.user_timeline(params[:search_string1], options = {:count=>"200", :page=> i}).each do |twitter|
          text = twitter['text']
          if text =~ /^@#{params[:search_string2]}\s/
            reply1.push(["#{twitter['created_at']}", "#{twitter['text']}"])
          end
        end
      }
    rescue Twitter::Error::BadGateway, Twitter::Error::BadRequest, Twitter::Error::EnhanceYourCalm, Twitter::Error::Forbidden, Twitter::Error::InternalServerError, Twitter::Error::NotAcceptable, Twitter::Error::NotFound, Twitter::Error::ServiceUnavailable, Twitter::Error::Unauthorized
      flash[:notice] = 'Maybe Twitter is down... Or check the name you input.'
    end

    begin    
      reply2 = Array.new

      i = 0
      #3200Tweets are MAX.
      how_many_tweets = params[:how_many_tweets].to_i ** 2
      how_many_tweets.times {
        i += 1
        Twitter.user_timeline(params[:search_string2], options = {:count=>"200", :page=> i}).each do |twitter|
          #text = "#{twitter['text']}"
          text = twitter['text']
          if text =~ /^@#{params[:search_string1]}\s/
            reply2.push(["#{twitter['created_at']}", "#{twitter['text']}"])
          end
        end
      }
    rescue Twitter::Error::BadGateway, Twitter::Error::BadRequest, Twitter::Error::EnhanceYourCalm, Twitter::Error::Forbidden, Twitter::Error::InternalServerError, Twitter::Error::NotAcceptable, Twitter::Error::NotFound, Twitter::Error::ServiceUnavailable, Twitter::Error::Unauthorized
      flash[:notice] = 'Maybe Twitter is down... Or check the name you input.'
    end

    #sometimes reply1 & reply2 return the same result. so, not [+] but [|] is preferable.
    conversations = reply1 | reply2
    conversations.uniq!
    conversations.sort!
    @conversations = conversations
    
  end
end
