# Welcome to OK Ready

# App Setup - Gems, etc.
RACK_ENV ||= ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
DATABASE_URL ||= ENV['DATABASE_URL'] ||= 'postgres://localhost/okready'

# Gems
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

# App Configuration
set :database, DATABASE_URL

# Root Handler
get '/' do
  erb :index
end

# Twilio SMS endpoint
post '/txt' do
  # https://www.twilio.com/docs/api/twiml
  response = Twilio::TwiML::Response.new do |r|
    r.Sms "Not implemented yet bro."
  end

  content_type :xml
  response.text
end

# Twilio Voice Endpoint
get '/voice' do
  # http://twilio-ruby.readthedocs.org/en/latest/usage/twiml.html
  response = Twilio::TwiML::Response.new do |r|
    r.play "http://#{request.env["HTTP_HOST"]}/mp3/hey.m4a"
  end

  content_type :xml
  response.text
end
