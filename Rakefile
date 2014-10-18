require 'bundler/setup'
require "./app"
require "sinatra/activerecord/rake"

desc "Run a local server."
task :local do
  Kernel.exec("shotgun -s thin -p 9393")
end
