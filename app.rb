# Welcome to OK Ready

# App Setup - Gems, etc.
RACK_ENV ||= ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

get '/' do
  erb :index
end

post '/txt' do
  # https://www.twilio.com/docs/api/twiml
  response = Twilio::TwiML::Response.new do |r|
    r.Sms "Not implemented yet bro."
  end

  response.text
end

get '/voice' do
  # http://twilio-ruby.readthedocs.org/en/latest/usage/twiml.html
  response = Twilio::TwiML::Response.new do |r|
    r.play "http://#{request.env["HTTP_HOST"]}/mp3/hey.m4a"
  end

  response.text
end
