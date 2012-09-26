require "httparty"

module HttpStatsd
  class Client
    include HTTParty

    def initialize(opts = {})
      @base_uri = opts[:base_uri]
      @auth = {:username => opts[:username], :password => opts[:password]}
    end

    def increment(name, sample_rate = nil)
      query = {:name => name}
      query.merge!({:sample_rate => sample_rate}) if sample_rate
      request(:increment, query)
    end

    def decrement(name, sample_rate = nil)
      query = {:name => name}
      query.merge!({:sample_rate => sample_rate}) if sample_rate
      request(:decrement, query)
    end

    def count(name, value, sample_rate = nil)
      query = {:name => name, :value => value}
      query.merge!({:sample_rate => sample_rate}) if sample_rate
      request(:count, query)
    end

    def gauge(name, value)
      query = {:name => name, :value => value}
      request(:gauge, query)
    end

    def timing(name, value, sample_rate = nil)
      query = {:name => name, :value => value}
      query.merge!({:sample_rate => sample_rate}) if sample_rate
      request(:timing, query)
    end

    private
    def request(action, query = {})
      options = {:basic_auth => @auth, :query => query}
      self.class.get("#{@base_uri}/#{action}", options)
    end
  end
end
