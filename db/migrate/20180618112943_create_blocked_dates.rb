class CreateBlockedDates < ActiveRecord::Migration[5.2]
  def change
    create_table :blocked_dates do |t|

      t.datetime :blocked_date
      t.integer :blocked_month
      t.integer :blockable_id
      t.string :blockable_type
      t.integer :place_id
      t.timestamps
    end
  end
end
