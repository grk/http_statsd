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

  describe "batch" do
    it "should make a single request with multiple metrics" do
      stub_request(:post, "api1:pass1@localhost/batch").
        with(:body => {:metrics => "count metric.one 1 0.2\ngauge metric.two 2"})
      client.batch do |b|
        b.count("metric.one", 1, 0.2)
        b.gauge("metric.two", 2)
      end
    end
  end

  describe HttpStatsd::Client::BatchOperation do
    let(:batch) { HttpStatsd::Client::BatchOperation.new }

    describe "#metrics" do
      it "is initially an empty array" do
        batch.metrics.should eql([])
      end
    end

    describe "#increment" do
      it "should add an increment metric to the batch" do
        batch.increment("metric.one", 0.2)
        batch.metrics.should eql(["count metric.one 1 0.2"])
      end
    end

    describe "#decrement" do
      it "should add an decrement metric to the batch" do
        batch.decrement("metric.one", 0.2)
        batch.metrics.should eql(["count metric.one -1 0.2"])
      end
    end

    describe "#count" do
      it "should add a count metric to the batch" do
        batch.count("metric.one", 12, 0.2)
        batch.metrics.should eql(["count metric.one 12 0.2"])
      end
    end

    describe "#gauge" do
      it "should add a gauge metric to the batch" do
        batch.gauge("metric.one", 12)
        batch.metrics.should eql(["gauge metric.one 12"])
      end
    end

    describe "#timing" do
      it "should add a timing metric to the batch" do
        batch.timing("metric.one", 12, 0.2)
        batch.metrics.should eql(["timing metric.one 12 0.2"])
      end
    end

  end
end
