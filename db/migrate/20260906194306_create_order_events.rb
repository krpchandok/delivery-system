class CreateOrderEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :order_events do |t|
      t.string :order_id
      t.string :status
      t.string :idempotency_key
      t.jsonb :payload

      t.timestamps
    end
  end
end
