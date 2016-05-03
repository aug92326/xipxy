require 'fileutils'
preload_app true
timeout 5
worker_processes 4
listen ENV["UNICORN_SOCKET"], backlog: 1024

# not to start nginx before app/dyno is loaded
before_fork do |server, worker|
  FileUtils.touch('/tmp/app-initialized')
end