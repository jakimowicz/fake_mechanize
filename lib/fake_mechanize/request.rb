module FakeMechanize
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
    
    def ==(alt)
      method == alt.method and uri == alt.uri and request_headers == alt.request_headers
    end
  end # Request
end # FakeMechanize