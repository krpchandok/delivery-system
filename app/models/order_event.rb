class OrderEvent < ApplicationRecord
    enum :status, { placed: "placed", shipped: "shipped", delivered: "delivered", cancelled: "cancelled" }
    has_many :deliveries
    validates :idempotency_key, uniqueness: true
end
