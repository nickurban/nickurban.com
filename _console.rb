#Dir["_plugins/*.rb"].each {|file| require file }

require './_plugins/bundler.rb'

require 'irb'
ARGV.clear
IRB.start

