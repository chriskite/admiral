require 'rubygems'
require 'bundler/setup'
Bundler.require :default
require 'admiral/config'

module Admiral
  VERSION = '0.0.0'
  ETCD_HOST = '172.17.42.1' # Host IP in CoreOS docker containers

  class << self
    def etcd
      @etcd ||= Etcd.client(host: ETCD_HOST)
    end
  end

end
