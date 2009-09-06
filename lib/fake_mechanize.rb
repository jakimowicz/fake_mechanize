require 'rubygems'
require 'mechanize'

module FakeMechanize
  # Supported http verbs
  HttpVerbs = [:get, :post]
end

require 'fake_mechanize/request'
require 'fake_mechanize/error_request'
require 'fake_mechanize/responder'
require 'fake_mechanize/agent'