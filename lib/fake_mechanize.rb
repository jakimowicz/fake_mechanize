require 'rubygems'
require 'mechanize'

module FakeMechanize
  HttpVerbs = [:head, :get, :post, :put, :delete]
end

require 'fake_mechanize/request'
require 'fake_mechanize/error_request'
require 'fake_mechanize/responder'
require 'fake_mechanize/agent'