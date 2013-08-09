#!/usr/bin/ruby
require './tools'

deployer = Deployer.new
unless deployer.deploy
	exit 1
end
