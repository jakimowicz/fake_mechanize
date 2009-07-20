module FakeMechanize
  class Responder
    def initialize(responses, errors)
      @responses, @errors = responses, errors
    end
    
    def error(args)
      if args[:method]
        @errors << ErrorRequest.new(args)
      else
        HttpVerbs.each do |method|
          @errors << ErrorRequest.new({:method => method}.merge(args))
        end
      end
    end
    
    HttpVerbs.each do |method|
      module_eval <<-EOE, __FILE__, __LINE__
        def #{method}(args = {})
          @responses << Request.new({:method => :#{method}}.merge(args))
        end
      EOE
    end
  end # Responder
end # FakeMechanize