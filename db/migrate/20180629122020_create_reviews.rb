class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :reviewable_id
      t.string :reviewable_type
      t.string :content
      t.float :overall_rating
      t.integer :accuracy
      t.integer :amenities
      t.integer :checkin
      t.integer :communication
      t.integer :cleanliness
      t.integer :location
      t.integer :service
      t.integer :food_quality
      t.timestamps
    end
  end
end
