=begin
// 通过rabbitMQ直接发来的任务，其before 类的callback不被调用。
// JobClassName.perform_later 会触发正常流程。
// 必须是json
{
    "job_class": "WsneakersJob", //类名
    "job_id": "e2be591c-1ec9-415d-a7a5-49b911f395b8", // 随意
    "provider_job_id": null,
    "queue_name": "default", // 不重要，建议和queue一样。便于排错。
    "priority": null,
    "arguments": [ //传递给perform的参数。
       {
            "a": 1,
            "what":3389
        }
    ],
    "executions": 0,
    "locale": "en"
}
=end
class WsneakersJob < ApplicationJob
  ActiveJob::Base.queue_adapter = :sneakers
  rescue_from(StandardError) do |exception|
    Rails.logger.error "[#{self.class.name}] Hey, something was wrong with you job #{exception.to_s}"
  end
  queue_as do
    logger.info "queue"
    :default
  end

  before_enqueue do |j|
    logger.info "j"
  end
  around_perform do |j, b|
    logger.info "around"
    b.call
  end

  def perform(*args)
    logger.info "wsneakers_job in perform "
    logger.info args
    # Do something later

  end
end
