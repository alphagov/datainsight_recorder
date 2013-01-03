def create_mock_queue(exchange, queue_name=nil)
  bunny_client = mock()
  Bunny.should_receive(:new).and_return(bunny_client)
  bunny_client.should_receive(:start)

  queue = mock()
  if queue_name.nil?
    bunny_client.should_receive(:queue).and_return(queue)
  else
    bunny_client.should_receive(:queue).with(queue_name).and_return(queue)
  end
  bunny_client.should_receive(:exchange).and_return(exchange)

  queue
end

def bind_to_topics(queue, exchange, topics)
  topics.each do |topic|
    queue.should_receive(:bind).with(exchange, key: topic)
  end

end

def should_listen_to_topics(*topics)
  queue = create_mock_queue(:my_exchange)
  bind_to_topics(queue, :my_exchange, topics)

  queue.should_receive(:subscribe)
end