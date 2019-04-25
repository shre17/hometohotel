class CreateProvideItems < ActiveRecord::Migration[5.2]
  def change
    create_table :provide_items do |t|

      t.string :category
      t.string :name
      t.text :description
      t.boolean :is_alcohol
      t.boolean :compliance_with_local_alcohol_laws
      t.integer :experience_id

      t.timestamps
    end
  end
end
