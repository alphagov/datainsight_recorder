require_relative "spec_helper"
require_relative "../lib/datainsight_recorder/recorder"
require_relative "../lib/datainsight_recorder/test_helpers"

class MyRecorder
  include DataInsight::Recorder::AMQP
end

describe "Recorder" do
  it "should fail if the routing_keys method is not overriden" do
    recorder = MyRecorder.new

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

  it "should listen to a single topic" do
    recorder = MyRecorder.new
    recorder.stub(:routing_keys).and_return(["foo"])

    should_listen_to_topics("foo")

    recorder.run
  end

  it "should listen to many topics" do
    recorder = MyRecorder.new
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