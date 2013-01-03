require "bunny"
require "json"

module DataInsight
  module Recorder
    module AMQP
      def run
        queue.subscribe do |msg|
          begin
            logger.debug { "Received a message: #{msg}" }
            update_message(parse_amqp_message(msg))
          rescue Exception => e
            logger.error { e }
          end
        end
      end

      # This must be unique across recorders.
      def queue_name
        raise NotImplementedError
      end

      def routing_keys
        raise NotImplementedError
      end

      def update_message(message)
        raise NotImplementedError
      end

      def queue
        @queue ||= create_queue
      end

      def create_queue
        client = Bunny.new ENV["AMQP"]
        client.start
        queue = client.queue(queue_name)
        exchange = client.exchange("datainsight", :type => :topic)

        routing_keys.each do |key|
          queue.bind(exchange, :key => key)
          logger.info("Bound to #{key}, listening for events")
        end

        queue
      end

      def parse_amqp_message(raw_message)
        message = JSON.parse(raw_message[:payload], :symbolize_names => true)
        message[:envelope][:_routing_key] = raw_message[:delivery_details][:routing_key]
        message
      end
    end
  end
end