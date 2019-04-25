class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|

      t.string :category
      t.string :name
      t.text :description
      t.boolean :is_alcohol
      t.boolean :compliance_with_local_alcohol_laws
      t.boolean :bring
      t.boolean :provide

      # t.integer :experience_id
      t.integer :itemable_id
      t.string  :itemable_type

      t.timestamps
    end
  end
end
