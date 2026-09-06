class Delivery < ApplicationRecord
  enum :status, { placed: "placed", shipped: "shipped", delivered: "delivered", cancelled: "cancelled" }

  belongs_to :order_event
  belongs_to :subscription
end
