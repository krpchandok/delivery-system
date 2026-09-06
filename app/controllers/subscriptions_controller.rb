class SubscriptionsController < ApplicationController
    def create
      subscription = Subscription.new(subscription_params)
      subscription.secret = SecureRandom.hex(32)
  
      if subscription.save
        render json: subscription, status: :created
      else
        render json: subscription.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def subscription_params
      params.expect(subscription: [:endpoint_url, :active, event_types: []])
    end
  end