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
  # Agent acts like the original Mechanize::Agent but totally offline.
  # It provides a respond_to method to predefine queries and their answers.
  class Agent
    attr_accessor :cookie_jar

    def initialize(&block)
      @cookie_jar = WWW::Mechanize::CookieJar.new
      @responses  = []
      @errors     = []
      @history    = []
      
      respond_to(&block) if block_given?
    end
  
    def respond_to
      reset_responses!
      yield Responder.new(@responses, @errors) if block_given?
      @errors << ErrorRequest.new(:status => 404, :body => "not found")
    end
    
    def assert_queried(method, uri, options = {})
      request = Request.new(:method => method, :uri => uri, :parameters => options[:parameters])
      @history.any? {|history_query| history_query == request}
    end
    
    def get(options, parameters = nil)
      if options.is_a? Hash
        # TODO raise a Mechanize exception
        raise "no url specified" unless url = options[:url]
        parameters = options[:params]
      else
        url = options
      end
      return_mechanize_response Request.new(:method => :get, :uri => url, :parameters => parameters)
    end
    
    def post(url, query = {})
      return_mechanize_response Request.new(:method => :post, :uri => url, :parameters => query)
    end
    
    HttpVerbs.each do |method|
      module_eval <<-EOE, __FILE__, __LINE__
        def was_#{method}?(uri, options = {})
          assert_queried(:#{method}, uri, options)
        end
      EOE
    end
    
    protected
    def return_mechanize_response(given_request)
      @history << given_request
      request = search_for_request(given_request)
      page = WWW::Mechanize::File.new(URI.parse(given_request.uri), request.response_headers, request.body, request.status)
      raise WWW::Mechanize::ResponseCodeError.new(page) if request.status != 200
      page
    end
    
    def search_for_request(given_request)
      @responses.find {|request| request == given_request} || search_for_error_request(given_request)
    end
    
    # Search an error query in the error query list using match value for a request,
    # the higher match will be the one returned (see ErrorRequest::match)
    def search_for_error_request(given_request)
      @errors.max_by {|request| request.match(given_request)}
    end
    
    # Delete all predefined responses
    def reset_responses!
      @responses.clear
    end
  end # Agent
end # FakeMechanize