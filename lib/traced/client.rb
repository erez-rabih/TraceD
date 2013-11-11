module TraceD
  class Client
    class << self
      def set(client)
        @client = client
      end

      def increment(stat)
        @client.increment(stat)
      end
      
      def time(stat)
        @client.time(stat) do
          yield
        end
      end
    end
  end
end
