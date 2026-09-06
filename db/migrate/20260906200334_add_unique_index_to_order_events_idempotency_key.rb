class AddUniqueIndexToOrderEventsIdempotencyKey < ActiveRecord::Migration[8.1]
  def change
    add_index :order_events, :idempotency_key, unique: true
  end
end