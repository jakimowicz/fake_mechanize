module FakeMechanize
  # ErrorRequest is like a traditionnal request, but implements features to match "error" cases :
  # if you have an authentication process which auth user with only one login/password couple,
  # you can define an ErrorRequest which will always match if parameters do not match your login/password.
  # ErrorRequest also implements a <tt>match</tt> function which compute a matching value given another request.
  class ErrorRequest < Request
    # List of non matching parameters
    attr_reader :params_not_equal
    
    # Initialize an ErrorRequest.
    # <tt>args</tt> takes all Request options and an additionnal <tt>:params_not_equal</tt> option
    # to define a hash of parameters that should not match.
    def initialize(args = {})
      super
      @params_not_equal = args[:params_not_equal]
    end
    
    # Compute a match between <tt>alt</tt> and current instance, returning an integer.
    # Computation is based on http method, uri and request_headers.
    # The idea behind this match rate is to find the best ErrorRequest matching a query.
    def match(alt)
      count = 0

      # Simple calculations
      count += 1 if method  == alt.method
      count += 1 if uri     == alt.uri

      # More complicated: evaluates if params are equals or if they are different on purpose
      # TODO : handle headers
      if !parameters.empty? and parameters == alt.parameters
        count += 1
      elsif method == alt.method and uri == alt.uri and parameters != params_not_equal
        count += 1
      end

      count
    end
  end # ErrorRequest
end # FakeMechanize