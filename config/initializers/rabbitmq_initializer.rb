class RabbitQueueService
  def self.logger
    Rails.logger.tagged("bunny") do
      @@_logger ||= Rails.logger
    end
  end

  def self.connection
    @@_connection ||= begin
      instance = Bunny.new(
        addresses: "127.0.0.1",
        username: "admin",
        password: "admin",
        vhost: "/",
        automatically_recover: true,
        connection_timeout: 2,
        continuation_timeout: (ENV["BUNNY_CONTINUATION_TIMEOUT"] || 10_000).to_i,
        logger: RabbitQueueService.logger,
      )
      instance.start
      instance
    end
  end

  ObjectSpace.define_finalizer(R514::Application, proc { puts "Closing rabbitmq connections"; RabbitQueueService.connection.close })
end
