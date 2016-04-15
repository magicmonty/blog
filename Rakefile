require "./tools"#

desc "Help"
task :default do
	puts "Usage:"
	puts "rake build: Builds the blog"
	puts "rake preview: Preview the blog"
	puts "rake deploy: deploys the blog to the web server"
end

desc "Compiles the SASS files"
task :compass do
	system("compass compile")
end

desc "Builds the blog via Wintersmith"
task :build => [:compass] do
	deployer = Deployer.new
	deployer.built?
end

desc "Deploys the blog to the web server"
task :deploy => [:build] do
	deployer = Deployer.new
	deployer.deploy_without_build
end

desc "Previews the blog"
task :preview => [:build] do
	exec("./node_modules/.bin/Wintersmith preview -p 9090")
end