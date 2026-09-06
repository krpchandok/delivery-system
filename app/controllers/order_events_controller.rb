class OrderEventsController < ApplicationController
    def create
      existing = OrderEvent.find_by(idempotency_key: order_event_params[:idempotency_key])
      if existing
        render json: existing, status: :ok
        return
      end
  
      order_event = OrderEvent.new(order_event_params)
  
      if order_event.save
        matching_subscriptions = Subscription.where(active: true)
                                              .where("? = ANY(event_types)", order_event.status)
  
        matching_subscriptions.each do |subscription|
            delivery = Delivery.create!(order_event: order_event, subscription: subscription, status: :pending)
            DeliveryJob.perform_async(delivery.id)
        end
  
        render json: order_event, status: :created
      else
        render json: order_event.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def order_event_params
      params.expect(order_event: [:order_id, :status, :idempotency_key, :payload])
    end
  end