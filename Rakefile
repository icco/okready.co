require 'bundler/setup'
require "./app"
require "sinatra/activerecord/rake"

# Just a simple test for travis showing we can parse the app and connect to a
# db.
task :default => "db:version"

desc "Run a local server."
task :local do
  Kernel.exec("shotgun -s thin -p 9393")
end
