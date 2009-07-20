module FakeMechanize
  # Request represents a request made to the server with its specific headers and its answer body, headers
  # and status (http code)
  class Request
    attr_reader :method, :uri, :request_headers, :body, :status, :response_headers
    
    def initialize(args = {})
      # Query
      @method           = args[:method] || :get
      @uri              = args[:uri]
      @request_headers  = args[:request_headers] || {}
      
      # Answer
      @body             = args[:body]
      @status           = args[:status] || 200
      @response_headers = args[:response_headers] || {}
    end
    
    # evaluate if <tt>alt</tt> has the same query parameters as the current object.
    # Returns true if equal, false otherwise.
    # Evaluation is based on method, uri and request_headers.
    def ==(alt)
      method == alt.method and uri == alt.uri and request_headers == alt.request_headers
    end
  end # Request
end # FakeMechanize