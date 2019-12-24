# config/initializers/sneakers.rb
require "sneakers"
require "sneakers/handlers/maxretry"

module Connection
  def self.sneakers
    @_sneakers ||= begin
      Bunny.new(
        addresses: "127.0.0.1",
        username: "admin",
        password: "admin",
        vhost: "/",
        automatically_recover: true,
        connection_timeout: 2,
        continuation_timeout: (ENV["BUNNY_CONTINUATION_TIMEOUT"] || 10_000).to_i,
        #        logger:  LogStashLogger.new(type: :stdout, formatter: :json_lines)
      )
    end
  end
end

Sneakers.configure connection: Connection.sneakers,
                   exchange: "rails",            # AMQP exchange
                   exchange_options: {
                     durable: true,
                     arguments: {
                       'x-delayed-type': :direct,
                     },
                   },
                   runner_config_file: nil,                             # A configuration file (see below)
                   metric: nil,                                         # A metrics provider implementation
                   daemonize: false,                                     # Send to background
                   workers: "2".to_i,                # Number of per-cpu processes to run
                   log: STDOUT,                                         # Log file
                   pid_path: "sneakers.pid",                            # Pid file
                   timeout_job_after: 5.minutes,                        # Maximal seconds to wait for job
                   prefetch: 1.to_i,             # Grab 10 jobs together. Better speed.
                   threads: 3.to_i,               # Threadpool size (good to match prefetch)
                   env: ENV["RAILS_ENV"],                               # Environment
                   durable: true,                                       # Is queue durable?
                   ack: true,                                           # Must we acknowledge?
                   heartbeat: 5,                                        # Keep a good connection with broker
                   # TODO: implement exponential back-off retry
                   handler: Sneakers::Handlers::Maxretry,
                   retry_max_times: 10,                                  # how many times to retry the failed worker process
                   retry_timeout: 3 * 60 * 1000                        # how long between each worker retry duration

Sneakers.logger = Rails.logger #LogStashLogger.new(type: :stdout, formatter: :json_lines)
Sneakers.logger.level = Logger::INFO
