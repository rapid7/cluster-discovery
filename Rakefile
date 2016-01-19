require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'httparty'
require 'logger'

@my_logger = Logger.new(STDOUT)

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

def register_service(id:, ip:, tag:, status:)
  json_doc = format(%(
    {
      "Datacenter": "dc1",
      "Node": "foobar%{id}",
      "Address": "%{ip}",
      "Service": {
        "ID": "redis%{id}",
        "Service": "redis",
        "Tags": ["%{tag}", "v1"],
        "Address": "127.0.0.1",
        "Port": 8000
      },
      "Check": {
        "Node": "foobar%{id}",
        "CheckID": "service:redis1",
        "Name": "Redis health check",
        "Notes": "Script based health check",
        "Status": "%{status}",
        "ServiceID": "redis%{id}"
      }
    }
  ), id: id, ip: ip, tag: tag, status: status)

  consul_host = ENV['TEST_CONSUL_HOST']
  options = { logger: @my_logger, log_level: :debug, log_format: :curl }
  options[:body] = json_doc
  HTTParty.put("http://#{consul_host}:8500/v1/catalog/register", options)
end

task :refresh_fixtures do
  register_service(id: '1', ip: '192.168.10.10', tag: 'master', status: 'passing')
  register_service(id: '2', ip: '192.168.10.11', tag: 'slave', status: 'warning')
  register_service(id: '3', ip: '192.168.10.12', tag: 'master', status: 'critical')
  register_service(id: '4', ip: '192.168.10.13', tag: 'slave', status: 'passing')
  register_service(id: '5', ip: '192.168.10.14', tag: 'master', status: 'warning')
  register_service(id: '6', ip: '192.168.10.15', tag: 'slave', status: 'critical')
end

task default: [:spec, :rubocop]
