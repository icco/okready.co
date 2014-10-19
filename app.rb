# Welcome to OK Ready

# App Setup - Gems, etc.
RACK_ENV ||= ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
DATABASE_URL ||= ENV['DATABASE_URL'] ||= 'postgres://localhost/okready'

# Gems
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

require './models'
require './helpers'

# App Configuration
set :database, DATABASE_URL

# Root Handler
get '/' do
  erb :index
end

# Twilio SMS endpoint. This does three things:
#  - Walks the user through the signup flow
#  - Reacts to commands
#  - Logs progress on OKR
post '/txt' do
  # Log incomming Text message for history.
  Message.recieve params["From"], params["Body"]

  # https://www.twilio.com/docs/api/twiml
  response = Twilio::TwiML::Response.new do |r|
    r.Message act_on_text(params["From"], params["Body"])
  end

  content_type :xml
  response.text
end

# Twilio Voice Endpoint
get '/voice' do
  # http://twilio-ruby.readthedocs.org/en/latest/usage/twiml.html
  response = Twilio::TwiML::Response.new do |r|
    r.Play "http://#{request.env["HTTP_HOST"]}/mp3/hey.mp3"
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
  if content.eql? "RESET"
    user.destroy
    return "Bro. I just forgot about you."
  end

  if !user.setup?
    return welcome_flow user, content
  end

  if user.setup?
    return update_okr user, content
  end

  return "All set up."
end

##
# Update a users progress and send a progress update text
def update_okr user, content
  unless user.result.nil?
    user.update(result: user.result + content.to_i)
    MessageProgressWorker.new.async.later(60)
  end
end
#
##
# Walk through signup flow if we need to.
def welcome_flow user, content
  if user.objective.nil?
    user.update(objective: "")
    return "Set an objective!"
  elsif user.objective == "" && user.key.nil?
    user.update(objective: content)
    return "Units for result?"
  elsif user.objective != "" && user.key.nil?
    user.update(key: content)
    return "How many?"
  elsif user.result.nil?
    user.update(result: content.to_i)
    return "Cool! You're all set up. Your goal is \"#{user.objective}\". You need #{user.result} #{user.key} in 30 days to succeed."
  end
end
