require 'spec_helper'
require 'serverspec'

package = 'varnish'
services = [ 'varnish' ]
config_dir = '/etc/varnish'
user    = 'varnish'
group   = 'varnish'
ports   = [ 80, 81 ]
log_dir = '/var/log/varnish'
cache_dir = '/var/cache/varnish'
cache_size = '1024M'
ncsa_dir = '/var/log/varnish'

case os[:family]
when 'freebsd'
  services = %w[ varnishd varnishlog varnishncsa ]
  package = 'varnish4'
  config_dir = '/usr/local/etc/varnish'
end

config  = "#{config_dir}/default.vcl"
another_config = "#{config_dir}/example.vcl"

describe package(package) do
  it { should be_installed }
end 

describe file(config) do
  it { should be_file }
  its(:content) { should match /backend default {/ }
  its(:content) { should match Regexp.escape('.host = "127.0.0.1";') }
end

describe file(another_config) do
  it { should be_file }
  its(:content) { should match /backend default {/ }
  its(:content) { should match Regexp.escape('.host = "127.0.0.1";') }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(cache_dir) do
  it { should exist }
  it { should be_mode 700 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(ncsa_dir) do
  it { should exist }
  it { should be_mode 755 }
end

case os[:family]
when 'freebsd'
  describe file('/etc/rc.conf.d/varnishd') do
    it { should be_file }
    its(:content) { should match Regexp.escape('varnishd_listen=":80"') }
    its(:content) { should match Regexp.escape('varnishd_admin="localhost:81"') }
    its(:content) { should match Regexp.escape('varnishd_hash="classic,16383"') }
    escaped = Regexp.escape(cache_dir)
    its(:content) { should match /varnishd_storage="file,#{escaped},#{cache_size}"/ }
    its(:content) { should match Regexp.escape('varnishd_jailuser="varnish"') }
    its(:content) { should match Regexp.escape('varnishd_extra_flags=""') }
  end
  describe file('/etc/rc.conf.d/varnishlog') do
    it { should be_file }
    its(:content) { should match /varnishlog_file="/ }
  end
  describe file('/etc/rc.conf.d/varnishncsa') do
    it { should be_file }
    its(:content) { should match Regexp.escape('varnishncsa_file="/var/log/varnishncsa/varnishncsa.log"') }
  end
end

services.each do |s|
  describe service(s) do
    it { should be_running }
    it { should be_enabled }
  end
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe file("#{ config_dir }/secret") do
  it { should be_file }
  it { should be_mode 700 }
  its(:content) { should match /password/ }
end

describe command("sudo varnishadm -S #{config_dir}/secret -T localhost:81 ping") do
  its(:stdout) { should match /PONG \d+ 1.0/ }
  its(:stderr) { should match /^$/ }
end

describe command('fetch http://127.0.0.1/foo') do
  its(:stdout) { should match /^$/ }
  its(:stderr) { should match Regexp.escape('fetch: http://127.0.0.1/foo: Service Unavailable') }
end

def valid_json?(json)
  require 'json'
  begin
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end

describe "json access log" do
  it 'should be valid json' do
    line = command("tail -n1 #{ncsa_dir}/access.json").stdout
    expect(valid_json?(line)).to eq(true)
  end
end
