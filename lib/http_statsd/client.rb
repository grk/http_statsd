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
      get(:increment, query)
    end

    def decrement(name, sample_rate = nil)
      query = {:name => name}
      query.merge!({:sample_rate => sample_rate}) if sample_rate
      get(:decrement, query)
    end

    def count(name, value, sample_rate = nil)
      query = {:name => name, :value => value}
      query.merge!({:sample_rate => sample_rate}) if sample_rate
      get(:count, query)
    end

    def gauge(name, value)
      query = {:name => name, :value => value}
      get(:gauge, query)
    end

    def timing(name, value, sample_rate = nil)
      query = {:name => name, :value => value}
      query.merge!({:sample_rate => sample_rate}) if sample_rate
      get(:timing, query)
    end

    def batch
      batch_operation = BatchOperation.new
      yield batch_operation
      post(:batch, {:metrics => batch_operation.metrics.join("\n")})
    end

    private
    def get(action, query = {})
      options = {:basic_auth => @auth, :query => query}
      self.class.get("#{@base_uri}/#{action}", options)
    end

    def post(action, body = {})
      options = {:basic_auth => @auth, :body => body}
      self.class.post("#{@base_uri}/#{action}", options)
    end

    class BatchOperation
      attr_accessor :metrics

      def initialize
        @metrics = []
      end

      def increment(name, sample_rate = nil)
        @metrics << "count #{name} 1 #{sample_rate}".strip
      end

      def decrement(name, sample_rate = nil)
        @metrics << "count #{name} -1 #{sample_rate}".strip
      end

      def count(name, value, sample_rate = nil)
        @metrics << "count #{name} #{value} #{sample_rate}".strip
      end

      def gauge(name, value)
        @metrics << "gauge #{name} #{value}".strip
      end

      def timing(name, value, sample_rate = nil)
        @metrics << "timing #{name} #{value} #{sample_rate}".strip
      end
    end
  end
end
