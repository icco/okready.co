require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

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
