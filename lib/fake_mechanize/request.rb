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
    
    # Create a new Request with the following options :
    # * <tt>:method</tt>: http method (verb) to respond to (:get, :post, ...).
    # * <tt>:uri</tt> or <tt>:url</tt>: string which represents the queried url.
    # * <tt>:request_headers</tt>: optionnals headers passed while querying.
    # * <tt>:parameters</tt>: an optionnals hash of parameters, like the one passed in an html form or inlined in a get query.
    # * <tt>:body</tt>: body that should be returned if query match. Defaut is nil.
    # * <tt>:status</tt>: http status response code (200, 404, ...). Default is 200.
    # * <tt>:response_headers</tt>: an optionnal hash for response headers.
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