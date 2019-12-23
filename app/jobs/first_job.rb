class FirstJob < ApplicationJob
  self.queue_adapter = :sidekiq
  queue_as do
    logger.info "queue"
    :default
  end

  before_enqueue do |j|
    logger.info "j"
  end
  around_perform do |j, b|
    b.call
  end

  def perform(*args)
    sleep 10
    x = 1024
    x += 20155
    # Do something later
    logger.info "hello, world!"
  end
end
