module FakeMechanize
  # Agent acts like the original Mechanize::Agent but totally offline.
  # It provides a respond_to method to predefine queries and their answers.
  class Agent
    # Represents a cookie jar built from WWW::Mechanize::CookieJar
    attr_accessor :cookie_jar

    # Create a new fake agent.
    # Can be initialized with a block, see <tt>respond_to</tt> for more details.
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
    
    # Returns true if query defined by <tt>method</tt>, <tt>uri</tt> and <tt>options</tt> was made.
    # False otherwise.
    # * <tt>method</tt> can be one of the following: :get, :post.
    # * <tt>uri</tt> is a String that represents the called url.
    # * <tt>options</tt> is an optional hash to specify parameters, headers ... Only :parameters options is actually supported.
    def assert_queried(method, uri, options = {})
      request = Request.new(:method => method, :uri => uri, :parameters => options[:parameters])
      @history.any? {|history_query| history_query == request}
    end
    
    # Get method. Called like get method from the real Mechanize gem.
    # Get can be achieved by two ways :
    # * <tt>options</tt> is a String representing the url to call and <tt>parameters</tt> a hash for the parameters.
    # * <tt>options</tt> is a Hash with <tt>:url</tt> the url and <tt>:params</tt> the parameters.
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
    
    # Post method. Called like post method from the real Mechanize gem.
    # <tt>url</tt> is the url to post.
    # <tt>query</tt> is a Hash of parameters.
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
    # Add <tt>given_request</tt> to history, search if for a matching query
    # and returns a response or raise an error if http status is not 200.
    def return_mechanize_response(given_request)
      @history << given_request
      request = search_for_request(given_request)
      page = WWW::Mechanize::File.new(URI.parse(given_request.uri), request.response_headers, request.body, request.status)
      raise WWW::Mechanize::ResponseCodeError.new(page) if request.status != 200
      page
    end
    
    # Search through available <tt>@responses</tt> if <tt>given_request</tt> matches one of the defined responses.
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