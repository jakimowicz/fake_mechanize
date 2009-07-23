# = FakeMechanize module
# FakeMechanize provides methods and classes to write tests for applications which relies on Mechanize.
# == Examples
# 
module FakeMechanize
  # Agent acts like the original Mechanize::Agent but totally offline.
  # It provides a respond_to method to predefine queries and their answers.
  class Agent
    attr_accessor :cookie_jar

    def initialize
      @cookie_jar = WWW::Mechanize::CookieJar.new
      @responses  = []
      @errors     = []
      @history    = []
    end
  
    def respond_to
      reset_responses!
      yield Responder.new(@responses, @errors)
      @errors << ErrorRequest.new(:status => 404, :body => "not found")
    end
    
    def assert_queried(method, uri, params = {})
      request = Request.new(:method => method, :uri => uri, :request_headers => params)
      @history.any? {|history_query| history_query == request}
    end
    
    HttpVerbs.each do |method|
      module_eval <<-EOE, __FILE__, __LINE__
        def was_#{method}?(uri, params = {})
          assert_queried(:#{method}, uri, params)
        end
        
        def #{method}(uri, args = {})
          return_mechanize_response Request.new(:method => :#{method}, :uri => uri, :request_headers => args)
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
    
    def search_for_error_request(given_request)
      @errors.max_by {|request| request.match(given_request)}
    end
    
    def reset_responses!
      @responses.clear
    end
  end # Agent
end # FakeMechanize