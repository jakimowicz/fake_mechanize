module FakeMechanize
  # Request represents a request made to the server with its specific headers and its answer body, headers
  # and status (http code)
  class Request
    # HTTP Method (get, post, ...)
    attr_reader :method
    # URI in its full form
    attr_reader :uri
    # Headers passed along with the request
    attr_reader :request_headers
    # Parameters passed with query (post or get)
    attr_reader :parameters
    # Body passed on answer
    attr_reader :body
    # HTTP Status code (200, 404, ...)
    attr_reader :status
    # Responses headers passed with status and body
    attr_reader :response_headers
    
    def initialize(args = {})
      # Query
      @method           = args[:method] || :get
      @uri              = args[:url] || args[:uri]
      @request_headers  = args[:request_headers] || {}
      @parameters       = args[:parameters] || {}
      
      # Answer
      @body             = args[:body]
      @status           = args[:status] || 200
      @response_headers = args[:response_headers] || {}
    end
    
    # evaluate if <tt>alt</tt> has the same query parameters as the current object.
    # Returns true if equal, false otherwise.
    # Evaluation is based on method, uri and request_headers.
    def ==(alt)
      method == alt.method and
        uri == alt.uri and
        request_headers == alt.request_headers and
        parameters == alt.parameters
    end
  end # Request
end # FakeMechanize