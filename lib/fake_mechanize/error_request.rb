module FakeMechanize
  class ErrorRequest < Request
    attr_reader :params_not_equal
    
    def initialize(args = {})
      super
      @params_not_equal = args[:params_not_equal]
    end
    
    def match(alt)
      count = 0

      # Simple calculations
      count += 1 if method  == alt.method
      count += 1 if uri     == alt.uri

      # More complicated: evaluates if params are equals or if they are different on purpose
      if !request_headers.empty? and request_headers == alt.request_headers
        count += 1
      elsif method == alt.method and uri == alt.uri and request_headers != params_not_equal
        count += 1
      end

      count
    end
  end # ErrorRequest
end # FakeMechanize