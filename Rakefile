desc 'Task to be used on travis-ci'
require 'rubygems'
require 'bundler/setup'
require 'html-proofer'

task :build do
  puts "## Building website with Jekyll"
  sh "bundle exec jekyll build"
end

task :serve do
  puts "## Building website with Jekyll"
  sh "bundle exec jekyll serve --drafts --livereload"
end

task test_amp: :build do
  sh 'amphtml-validator _site/amp/articles/**/*.html'
end

task test: :test_amp do
  puts "## Validating website via HMTLProofer"
  HTMLProofer.check_directory("./_site", {
    :http_status_ignore => [999],
    :check_favicon => true,
    :check_html => true,
    :file_ignore => [
      "./_site/googleb2485cfad909772b.html",
      "./_site/y_key_87dbcfe2ce094d82.html",
      /_site\/amp/
    ],
    :url_ignore => [
      /blog.pagansoft.de/,
      /www.avg.com/
    ]
  }).run
end

task travis: :test do
  puts "## Deploying website via rsync"
  success = system("sshpass -e rsync -avr --delete-after --delete-excluded _site/* ${SSHUSER}@blog.pagansoft.de:~/blog")

  fail unless success
end

task deploy: :test do
  puts "## Deploying website via rsync"
  success = system("rsync -avr --delete-after --delete-excluded _site/* -e ssh web:~/blog")

  fail unless success
end

