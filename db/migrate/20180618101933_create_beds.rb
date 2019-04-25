class CreateBeds < ActiveRecord::Migration[5.2]
  def change
    create_table :beds do |t|

      t.integer :double, default: 0
      t.integer :queen, default: 0
      t.integer :single, default: 0
      t.integer :sofa_bed, default: 0
      t.integer :king_bed, default: 0
      t.integer :couch, default: 0
      t.integer :bunk_bed, default: 0
      t.integer :floor_mattress, default: 0
      t.integer :air_mattress, default: 0
      t.integer :crib, default: 0
      t.integer :toddler_bed, default: 0
      t.integer :hammock, default: 0
      t.integer :water_bed, default: 0

      t.integer :bedroom_id
      t.timestamps
    end
  end
end
