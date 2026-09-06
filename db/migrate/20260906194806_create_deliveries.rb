class CreateDeliveries < ActiveRecord::Migration[8.1]
  def change
    create_table :deliveries do |t|
      t.references :order_event, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.string :status
      t.integer :attempt_count
      t.datetime :last_attempted_at
      t.integer :response_code

      t.timestamps
    end
  end
end
