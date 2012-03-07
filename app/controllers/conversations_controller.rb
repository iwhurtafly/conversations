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
      #Twitter.user_timeline(params[:user1_screen_name], options = {:count=>"200", :page=>"1"}).each do |twitter|
      Twitter.user_timeline(params[:search_string1], options = {:count=>"200", :page=>"1"}).each do |twitter|
        text = "#{twitter['text']}"
        #if text =~ /^@#{params[:user2_screen_name]}/
        if text =~ /^@#{params[:search_string2]}/
          reply1.push(["#{twitter['created_at']}", "#{twitter['text']}"])
        end
      end
    rescue Twitter::Error::BadGateway, Twitter::Error::BadRequest, Twitter::Error::EnhanceYourCalm, Twitter::Error::Forbidden, Twitter::Error::InternalServerError, Twitter::Error::NotAcceptable, Twitter::Error::NotFound, Twitter::Error::ServiceUnavailable, Twitter::Error::Unauthorized
      flash[:notice] = 'Maybe Twitter is down... Or check the name you input.'
    end

    begin    
      reply2 = Array.new
      #Twitter.user_timeline(params[:user2_screen_name], options = {:count=>"200", :page=>"1"}).each do |twitter|
      Twitter.user_timeline(params[:search_string2], options = {:count=>"200", :page=>"1"}).each do |twitter|
        text = "#{twitter['text']}"
        #if text =~ /^@#{params[:user1_screen_name]}/
        if text =~ /^@#{params[:search_string1]}/
          reply2.push(["#{twitter['created_at']}", "#{twitter['text']}"])
        end
      end
    rescue Twitter::Error::BadGateway, Twitter::Error::BadRequest, Twitter::Error::EnhanceYourCalm, Twitter::Error::Forbidden, Twitter::Error::InternalServerError, Twitter::Error::NotAcceptable, Twitter::Error::NotFound, Twitter::Error::ServiceUnavailable, Twitter::Error::Unauthorized
      flash[:notice] = 'Maybe Twitter is down... Or check the name you input.'
    end
    
    conversations = reply1 + reply2
    conversations.sort!
    @conversations = conversations
  end

end
