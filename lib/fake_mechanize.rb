require 'rubygems'
require 'mechanize'

# = FakeMechanize module
# FakeMechanize provides methods and classes to write offline tests for applications which relies on Mechanize.
# == Examples
#   # Initialize a fake agent
#   @http_agent = FakeMechanize::Agent.new
#   
#   # Create answers and their params
#   @http_agent.respond_to do |mock|
#
#     # Answers to get queries to http://api.example.com/users/count?group=students
#     # with the string "42"
#     mock.get :uri => "http://api.example.com/users/count",
#              :parameters => {:group => "students"},
#              :body => "42"
#
#     # Answers to post queries to http://api.example.com/users/3/activate
#     # with the string "true"
#     mock.post :uri => "http://api.example.com/users/3/activate",
#               :body => "true"
#
#     # Answers to post queries to http://api.example.com/users/authentify
#     # with the string "Qt5c1HWwCXDhKskMrBqMdQ".
#     # This example could be an authentication process
#     mock.post   :uri => "http://api.example.com/users/authentify",
#                 :parameters   => {:Email => 'jack@bauer.com', :Passwd => 'secure'},
#                 :body => "Qt5c1HWwCXDhKskMrBqMdQ"
#
#     # Will reply with an http error code of 403 with no body if the post query
#     # to http://api.example.com/users/authentify does not have specified parameters.
#     mock.error  :uri => "http://api.example.com/users/authentify",
#                 :params_not_equal  => {:Email => 'jack@bauer.com', :Passwd => 'secure'},
#                 :method => :post,
#                 :status => 403
#   end
#   
#   # Now you can use this agent like a real one
#   r = mock.get("http://api.example.com/users/count", :group => "students")
#   # => WWW::Mechanize::File
#   r.body # => "42"
#
#   # Posting
#   r = mock.post("http://api.example.com/users/authentify",
#                 :Email => "jack@bauer.com", :Passwd => "secure")
#   r.status # => 200
#   r.body   # => "Qt5c1HWwCXDhKskMrBqMdQ"
#
#   # Handling errors
#   r = mock.post("http://api.example.com/users/authentify",
#                 :Email => "jack@bauer.com", :Passwd => "bad")
#   r.status # => 403
#   r.body   # => nil
# 
module FakeMechanize
  # Supported http verbs
  HttpVerbs = [:get, :post]
end

require 'fake_mechanize/request'
require 'fake_mechanize/error_request'
require 'fake_mechanize/responder'
require 'fake_mechanize/agent'