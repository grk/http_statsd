require 'spec_helper'

describe HttpStatsd::Server do
  let(:statsd) { mock(Statsd).as_null_object }

  before(:all) do
    app.set :api_keys, {"app1" => "key1"}
  end

  before(:each) do
    authorize "app1", "key1"
    Statsd.stub(:new => statsd)
  end

  describe "api keys" do
    it "should allow valid api keys" do
      authorize "app1", "key1"
      get "/"
      last_response.should be_ok
    end

    it "should reject invalid api keys" do
      authorize "app2", "key2"
      get "/"
      last_response.status.should eql(401)
    end
  end

  describe "/increment" do
    it "should create statsd client with given host and port" do
      Statsd.should_receive(:new).with("localhost", 8125).and_return(statsd)
      get "/increment", :name => "metric.one"
    end

    it "should increment in statsd" do
      statsd.should_receive(:increment).with("metric.one", 0.1)
      get "/increment", :name => "metric.one", :sample_rate => "0.1"
    end
  end

  describe "/decrement" do
    it "should decrement in statsd" do
      statsd.should_receive(:decrement).with("metric.one", 0.1)
      get "/decrement", :name => "metric.one", :sample_rate => "0.1"
    end
  end

  describe "/count" do
    it "should count in statsd" do
      statsd.should_receive(:count).with("metric.one", 11.1, 0.1)
      get "/count", :name => "metric.one", :value => "11.1",
        :sample_rate => "0.1"
    end
  end

  describe "/gauge" do
    it "should store gauge in statsd" do
      statsd.should_receive(:gauge).with("metric.one", 11.1)
      get "/gauge", :name => "metric.one", :value => "11.1"
    end
  end

  describe "/timing" do
    it "should measure timing in statsd" do
      statsd.should_receive(:timing).with("metric.one", 11.1, 0.1)
      get "/timing", :name => "metric.one", :value => "11.1",
        :sample_rate => "0.1"
    end
  end

  describe "/batch" do
    it "should process batch metrics" do
      statsd.should_receive(:timing).with("metric.one", "11.1", 0.1)
      statsd.should_receive(:gauge).with("metric.two", "12.2", 0.2)
      statsd.should_receive(:count).with("metric.three", "13.3", 0.3)
      post "/batch", :metrics =>
        "timing metric.one 11.1 0.1\ngauge metric.two 12.2 0.2\n count metric.three 13.3 0.3"
    end
  end
end
