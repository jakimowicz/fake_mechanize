require 'rubygems'
require 'fake_mechanize'
require 'test/unit'

# Small module to transform an url into its tiny form through TinyURL service.
module TinyUrl
  TinyMatch         = /http:\/\/tinyurl.com\/[a-z0-9]+/i
  ApiAddress        = "http://tinyurl.com/api-create.php"
  
  class << self
    def url_to_tiny(url)
      return url if url.match(TinyMatch)
      @cache      ||= {}
      @cache[url] ||= mechanize_agent.get(ApiAddress, :url => url).body
    end
  
    def mechanize_agent
      @agent ||= WWW::Mechanize.new
    end
  end
end

# Test code part
# First, we have to define a FakeMechanize::Agent with some urls and their result
module TinyUrl
  def self.mechanize_agent
    if @http_agent.nil?
      @http_agent = FakeMechanize::Agent.new do |mock|
        mock.get :uri => ApiAddress,
          :parameters => {:url => "http://www.google.com"},
          :body => "http://tinyurl.com/dehdc"
        mock.get :uri => ApiAddress,
          :parameters => {:url => "https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2702-single-table-inherited-model-generator"},
          :body => "http://tinyurl.com/pucvt5"
      end
    end
    @http_agent
  end
end

# Now, we can write tests on this
class TinyUrlTest < Test::Unit::TestCase
  def test_url_to_tiny_should_convert_url
    assert_equal "http://tinyurl.com/dehdc", TinyUrl::url_to_tiny("http://www.google.com")
  end
end