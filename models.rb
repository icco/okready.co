require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

require './helpers'

##
# Holds User data. If a user has an account they have a row here.
#
# TODO(icco): Abstract out OKR data, right now they can only ever have one OKR.
# Suggested schema might be just phone_number in this table, and then another
# table holding all objectives. Each objective would need a deadline, which we
# currently don't have either.
class User < ActiveRecord::Base

  ##
  # Returns true if a user is properly configured.
  def setup?
    a = !self.telephone.empty?
    b = !self.objective.nil? && !self.objective.empty?
    c = !self.key.nil? && !self.key.empty?
    d = !self.result.nil? && self.result > 0
    return a && b && c && d
  end

  ##
  # Given a phone number, either finds or creates the user, makes sure it's
  # saved to db and returns the user.
  def self.get phone_number
    u = User.find_or_create_by(telephone: convert_to_e164(phone_number))
    u.save

    return u
  end
end

##
# Holds a record of a message.
class Message < ActiveRecord::Base

  ##
  # A log of messages we have sent. Calling this creates an object, makes the
  # Twilio API call and then writes to the Database as a log on success.
  def self.send to, message
    # TODO(icco): Implement.
  end

  ##
  # Written to when we get a message from Twilio.
  def self.recieve from, message
    p Message
    p Message.table_name
    m = create(from: from, text: message)
    m.save

    return m
  end
end
