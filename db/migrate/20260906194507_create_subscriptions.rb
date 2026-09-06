class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.string :endpoint_url
      t.string :secret
      t.string :event_types, array:true, default:[]
      t.boolean :active

      t.timestamps
    end
  end
end
