# Welcome to OK Ready

# App Setup - Gems, etc.
RACK_ENV ||= ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)
