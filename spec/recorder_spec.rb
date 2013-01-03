require_relative "spec_helper"
require_relative "../lib/datainsight_recorder/recorder"
require_relative "../lib/datainsight_recorder/test_helpers"

class MyRecorder
  include DataInsight::Recorder::AMQP
end

describe "Recorder" do

  it "should fail if no queue name is provided" do
    recorder = MyRecorder.new

    Bunny.should_receive(:new).and_return(mock())

    lambda { recorder.run }.should raise_error    
  end

  it "should fail if the routing_keys method is not overriden" do
    recorder = MyRecorder.new
    recorder.stub(:queue_name).and_return("foo")

    create_mock_queue(:my_exchange)

    lambda { recorder.run }.should raise_error
  end

  it "should not fail if the update_message method is not overriden" do
    # it will fail but this will be logged
    recorder = MyRecorder.new
    amqp_message = {
      delivery_details: {
        routing_key: "foo"
      },
      payload: '{"envelope":{}}'
    }
    queue = mock()
    recorder.stub(:queue).and_return(queue)
    queue.should_receive(:subscribe).and_yield(amqp_message)

    recorder.run
  end

  it "should receive the correct queue name" do
    recorder = MyRecorder.new
    recorder.stub(:queue_name).and_return("test_queue")
    recorder.stub(:routing_keys).and_return(["one", "two", "three"])

    queue = create_mock_queue(:my_exchange, "test_queue")
    bind_to_topics(queue, :my_exchange, ["one", "two", "three"])

    queue.should_receive(:subscribe)

    recorder.run
  end

  it "should listen to a single topic" do
    recorder = MyRecorder.new
    recorder.stub(:queue_name).and_return("foo")
    recorder.stub(:routing_keys).and_return(["foo"])

    should_listen_to_topics("foo")

    recorder.run
  end

  it "should listen to many topics" do
    recorder = MyRecorder.new
    recorder.stub(:queue_name).and_return("foo")
    recorder.stub(:routing_keys).and_return(["foo", "bar"])

    should_listen_to_topics("foo", "bar")

    recorder.run
  end

  it "should call update_message when amqp message is received" do
    recorder = MyRecorder.new

    queue = mock()
    recorder.stub(:queue).and_return(queue)

    amqp_message = {
      delivery_details: {
        routing_key: "foo"
      },
      payload: '{"envelope":{}}'
    }

    parsed_message = {
      envelope: {
        _routing_key: "foo"
      }
    }

    queue.should_receive(:subscribe).and_yield(amqp_message)

    recorder.should_receive(:update_message).with(parsed_message)

    recorder.run

  end
end