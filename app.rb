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
  p params
  response = Twilio::TwiML::Response.new do |r|
    r.Sms act_on_text(params["From"], params["Body"])
  end

  content_type :xml
  response.text
end

# Twilio Voice Endpoint
get '/voice' do
  # http://twilio-ruby.readthedocs.org/en/latest/usage/twiml.html
  response = Twilio::TwiML::Response.new do |r|
    r.play "http://#{request.env["HTTP_HOST"]}/mp3/hey.mp3"
  end

  content_type :xml
  response.text
end

##
# This contains most of the business logic and should always return the string
# we should send back to the user.
def act_on_text number, content
  # Get that user
  user = User.get number

  # Walk through signup flow if we need to.
  if user.objective.nil?
    return "Set an objective"
  elsif user.key.nil?
    return "Units for result?"
  elsif user.result.nil?
    return "How many?"
  end

  return "All set up."
end

##
# Takes in a phone number and converts it to E164, the international phone
# number format.
def convert_to_e164 raw_phone
  nrml = Phony.normalize(raw_phone)
  return Phony.format(
    nrml,
    :format => :international,
    :spaces => ''
  ).gsub(/\s+/, "") # Phony won't remove all spaces
end

# Models
class User < ActiveRecord::Base
  ##
  # Given a phone number, either finds or creates the user, makes sure it's
  # saved to db and returns the user.
  def self.get phone_number
    u = User.find_or_create_by(telephone: convert_to_e164(phone_number))
    u.save

    return u
  end
end
