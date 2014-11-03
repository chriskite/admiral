require 'rubygems'
require 'bundler/setup'
Bundler.require :default
require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'admiral/notifier'
require 'admiral/notifier_factory'
require 'admiral/config'
require 'admiral/state_monitor'

module Admiral
  VERSION = '0.0.0'
  DEFAULT_ETCD_HOST = '172.17.42.1' # Host IP in CoreOS docker containers

  class << self
    attr_accessor :etcd_host

    def etcd
      @etcd ||= Etcd.client(host: etcd_host || DEFAULT_ETCD_HOST)
    end

    def config
      @config ||= Admiral::Config.new
    end
  end

end
