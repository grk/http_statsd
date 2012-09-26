require 'spec_helper'

describe HttpStatsd::Client do
  let(:base_uri) { "http://localhost" }
  let(:username) { "api1" }
  let(:password) { "pass1" }
  let(:client) { HttpStatsd::Client.new(:base_uri => base_uri,
    :username => username, :password => password) }

  describe "increment" do
    it "should make a request with metric name and sample rate" do
      stub_request(:get, "api1:pass1@localhost/increment").
        with(:query => {:name => "metric.one", :sample_rate => "0.1"})
      client.increment("metric.one", "0.1")
    end
  end

  describe "decrement" do
    it "should make a request with metric name and sample rate" do
      stub_request(:get, "api1:pass1@localhost/decrement").
        with(:query => {:name => "metric.one", :sample_rate => "0.1"})
      client.decrement("metric.one", "0.1")
    end
  end

  describe "count" do
    it "should make a request with metric name, value and sample rate" do
      stub_request(:get, "api1:pass1@localhost/count").
        with(:query => {:name => "metric.one", :value => "11.1",
          :sample_rate => "0.1"})
      client.count("metric.one", 11.1, 0.1)
    end
  end

  describe "gauge" do
    it "should make a request with metric name and value" do
      stub_request(:get, "api1:pass1@localhost/gauge").
        with(:query => {:name => "metric.one", :value => "11.1"})
      client.gauge("metric.one", 11.1)
    end
  end

  describe "timing" do
    it "should make a request with metric name, value and sample rate" do
      stub_request(:get, "api1:pass1@localhost/timing").
        with(:query => {:name => "metric.one", :value => "11.1",
          :sample_rate => "0.1"})
      client.timing("metric.one", 11.1, 0.1)
    end
  end
end
