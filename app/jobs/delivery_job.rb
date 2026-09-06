class DeliveryJob
  include Sidekiq::Job
  queue_as :default

  require "net/http"
  require "uri"

  def perform(delivery_id)
    delivery = Delivery.find(delivery_id)
    payload = delivery.order_event.payload
    endpoint = delivery.subscription.endpoint_url

    uri = URI.parse(endpoint)
    response = Net::HTTP.post(uri, payload.to_json, "Content-Type" => "application/json")

    if response.is_a?(Net::HTTPSuccess)
      delivery.update!(status: :delivered, response_code: response.code, last_attempted_at: Time.current)
    else
      handle_failure(delivery, response.code)
    end
  rescue StandardError => e
    handle_failure(delivery, nil)
  end

  private

  RETRY_SCHEDULE = [30, 120, 600, 3600].freeze

  def handle_failure(delivery, response_code)
    delivery.increment!(:attempt_count)

    if delivery.attempt_count > RETRY_SCHEDULE.length
      delivery.update!(status: :exhausted, response_code: response_code, last_attempted_at: Time.current)
    else
      delivery.update!(status: :failed, response_code: response_code, last_attempted_at: Time.current)
      delay = RETRY_SCHEDULE[delivery.attempt_count - 1]
      self.class.perform_in(delay, delivery.id)
    end
  end
end
